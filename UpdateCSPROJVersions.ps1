param([string]$upgradeVersion)

function UpdateTargetVersion($csProj, $targetVersion){	
	$xml = New-Object xml
	$xml.PreserveWhitespace = $true;
	$xml.Load("$csProj")
	$currentVersion = $xml.Project.PropertyGroup[0].TargetFrameworkVersion
	write-host "Current Version: $currentVersion"	
	$xml.Project.PropertyGroup[0].TargetFrameworkVersion = "$targetVersion"
	$utf8WithBom = New-Object System.Text.UTF8Encoding($true)
	$sw = New-Object System.IO.StreamWriter($csProj, $false, $utf8WithBom)
	$xml.Save( $sw )
	$sw.Close()	
}

$basePath = resolve-path .
$csProj = ls "$basePath\*\*.csproj";
$desiredTargetVersion = "$upgradeVersion"
foreach ($proj in $csProj){
	$current = $proj.Name;
	write-host "Upgrading $current"
	$fullName = $proj.FullName;
	UpdateTargetVersion "$fullName" "$desiredTargetVersion"
	write-host "Complete upgrade of  $current to $desiredTargetVersion"
}

