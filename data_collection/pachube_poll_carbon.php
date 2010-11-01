<?php

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

$link = mysql_connect(MYSQL_SERVER, MYSQL_USER, MYSQL_PASSWORD);
if (!$link) {
    die('Could not connect: ' . mysql_error());
}
mysql_select_db (MYSQL_DB,$link);
$key=PACHUBE_API_KEY;
$result=mysql_query("SELECT count(*) n FROM feeds");
$values=mysql_fetch_array($result);
echo "Found $values[n] feeds\n";
$result=mysql_query("SELECT * FROM feeds");
while ($values=mysql_fetch_array($result)) {
  foreach ($values as $k=>$v) $$k=$v;
  echo $external_id." :: ";
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
      $cv=$sub_arr[current_value];
      if ($sub_arr[unit]=='Kilowatts') $cv*=1000;
      $kw=$cv/1000;
      $result3=mysql_query("SELECT amee_profile FROM feeds WHERE external_id='$external_id'");
      $values=mysql_fetch_array($result3);
      $sProfileUID = $values[0];
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
    } else echo "Can't open dom";
  } else echo "Can't open feed";
  curl_close($ch);
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
