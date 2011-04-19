<?php

/*
This version is called by pachube with a POST.  The payload is pachube EEML, JSON encoded.  So we just extract the new current value and apply it.
*/

// Include configuration file
require_once 'config.php';

// Include required files
if (PHP_VERSION>='5')
 require_once('domxml-php4-to-php5.php');
require_once 'Services/AMEE/DataItem.php';
require_once 'Services/AMEE/Profile.php';
require_once 'Services/AMEE/ProfileItem.php';

// Set up required definitions for use
$sProfileCategory = "home/energy/quantity";
$aProfileCategory = array(
    "type" => "electricity"
);

// Open the DB
$link = mysql_connect(MYSQL_SERVER, MYSQL_USER, MYSQL_PASSWORD);
if (!$link) {
    die('Could not connect: ' . mysql_error());
}
mysql_select_db (MYSQL_DB,$link);

$raw_post = file_get_contents("php://input");
$postdata = explode('=', $raw_post);

// Extract the data from POST
$trigger = stripslashes($postdata[1]);
$json = json_decode($trigger);
$environment_id = $json->{'environment'}->{'id'};
$datastream_id = $json->{'triggering_datastream'}->{'id'};
$cv = $json->{'triggering_datastream'}->{'value'}->{'value'};

// Check we're cool
$external_id="$environment_id:$datastream_id";
if ($external_id == ":") {
  echo "Illegal call"; exit;
}

$unit=get_unit($external_id);

// Now store it
$result=mysql_query("SELECT * FROM feeds WHERE external_id='$external_id'");
while ($values=mysql_fetch_array($result)) {
  foreach ($values as $k=>$v) $$k=$v;
  if ($unit=='Kilowatts') $cv*=1000;
  $kw=$cv/1000;
  $result2=mysql_query("SELECT amee_profile FROM feeds WHERE external_id='$external_id'");
  $values=mysql_fetch_array($result2);
  $sProfileUID = $values[0];
  $carbon = 0;
  try {
      // Create the AMEE API Profile
      $oProfile = new Services_AMEE_Profile($sProfileUID);
  
      // Create the AMEE API Data Item
      $oDataItem = new Services_AMEE_DataItem($sProfileCategory, $aProfileCategory);
  
      // Prepare the values for the new AMEE API Profile Item
      // The following values MUST be provided for this usage
      $aCompulsoryProfileItemValues = array(
        'energyConsumption' => $kw,
        'energyConsumptionUnit' => 'kWh',
        'energyConsumptionPerUnit' => 'h',
        'name' => time()
      );
  
      // Create the new AMEE API Profile Item
      $oProfileItem = new Services_AMEE_ProfileItem(array(
          $oProfile,
          $oDataItem,
          array_merge($aCompulsoryProfileItemValues)
      ));
  
      $aInfo = $oProfileItem->getInfo();
      $carbon=$aInfo['amount'];
  
  } catch (Exception $oException) {
  
      // An error occured
      echo "Error: " . $oException->getMessage() . "\n";
  
  }
  echo "$cv :: $carbon\n";
  $sql="UPDATE feeds SET current_value=$cv,current_carbon=$carbon,updated_at=NOW() WHERE external_id='$external_id'";
  if ($_GET[deb]) echo "$sql\n";
  mysql_query($sql);
}

// Annoyingly we have to go back to pachube just to get unit - grrr
function get_unit ($external_id) {
  $key=PACHUBE_API_KEY;
  list ($id,$sub)=split('\:',$external_id);
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_GET, true);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_URL, "http://api.pachube.com/v2/feeds/$id.xml?key=$key");
  if ($xml=curl_exec($ch)) {
    $dom=domxml_open_mem($xml);
    if ($dom) {
      $arr=dom_to_array($dom,"notification");
      $sub_arr=$arr[eeml][environment][data][$sub];
      $out=$sub_arr[unit];
    } else echo "Can't open dom";
  } else echo "Can't open feed";
  curl_close($ch);
  return $out;
}

#
#convert xml to array
#
function dom_to_array($dom,$arr) { 
  $node=$dom->first_child();
  $idx=0;
  while ($node) {
    if ($node->node_type()==XML_TEXT_NODE) {
      $text=trim($node->node_value());
      if ($text) $result=$text;
    } elseif ($node->node_type()==XML_ELEMENT_NODE) {
      $name=$node->node_name();
      if ($node->has_child_nodes()) {
         # should be strstr($arr,$name) or better way to detect arrays
         if ($name=="data") $result[$name][$idx++]=dom_to_array($node,$arr);
         else $result[$name]=dom_to_array($node,$arr);
      }
    }
    $node=$node->next_sibling();
  }  
  return $result; 
}
?>
