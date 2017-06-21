# # Referencing Assemblies in PowerShell Script
# $pathToAss2 = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer"
# $pathToAss4 = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer"
# # $pathToAss2 = "D:\Program Files\Microsoft Team Foundation Server 15.0\Version Control Proxy\Web Services\bin"
# # $pathToAss4 = "D:\Program Files\Microsoft Team Foundation Server 15.0\Version Control Proxy\Web Services\bin"
# echo "$pathToAss2\Microsoft.TeamFoundation.Client.dll"
# Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.Client.dll"
# echo "$pathToAss2\Microsoft.TeamFoundation.Common.dll"
# Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.Common.dll"
# echo "$pathToAss2\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"
# Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"
# echo "$pathToAss2\Microsoft.TeamFoundation.VersionControl.Client.dll"
# Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.VersionControl.Client.dll"
# echo "$pathToAss2\Microsoft.TeamFoundation.ProjectManagement.dll"
# Add-Type -Path "$pathToAss4\Microsoft.TeamFoundation.ProjectManagement.dll"
# echo "$pathToAss2\Microsoft.TeamFoundation.ProjectManagement.dll"
# Add-Type -Path "$pathToAss4\Microsoft.TeamFoundation.Build.Client.dll"



# # [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
# # [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")

# $serverName = "http://w4bibuild1701:8080/tfs/DefaultCollection"
# $teamProject = "SIA"

# $tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
# $buildserver = $tfs.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])
# $buildDefinitions = $buildServer.QueryBuilds("SIA")
# $buildDefinitions = $buildDefinitions | Sort

# foreach($buildDefinitionName in $buildDefinitions) 
# {
#         $buildDefinition = $buildserver.GetBuildDefinition($teamProject, $buildDefinitionName)
#         if ($buildDefinition.Enabled)
#         {
#             #if ($buildDefinitionName.Contains("(D") -or $buildDefinitionName.Contains("(T"))
#             #{
#                 Write-Output "Queuing build -> $buildDefinitionName"
#                 $buildRequest = $buildDefinition.CreateBuildRequest();
#                 $result = $buildserver.QueueBuild($buildRequest)
#             #}
#         }
#         else
#         {
#             Write-Output "$buildDefinitionName is disabled, skipping."
#         }
# }

$TFSInstanceURL = "http://w4bibuild1701:8080/tfs/"
$ProjectCollection = "DefaultCollection"
$TeamProject = "SIA"

echo $TFSInstanceURL+"/"+$ProjectCollection+"/"+$TeamProject+"/SIA/_apis/build/definitions?api-version=2.0"
$url = $TFSInstanceURL+"/"+$ProjectCollection+"/"+$TeamProject+"/_apis/build/definitions?api-version=2.0"
$releaseresponse = Invoke-RestMethod -Method Get -ContentType application/json -Uri  $url -UseDefaultCredentials


foreach ($build in $releaseresponse.value)
{

    $body_internal = 
                    @{ 
                        "definition" = @{ "id" = $build.Id  }
                    } | ConvertTo-Json -Compress -Depth 50

    $Uri = $TFSInstanceURL+"/"+$ProjectCollection+"/"+$TeamProject+"/_apis/build/builds?api-version=2.0"
    echo $uri
    $buildresponse = Invoke-RestMethod -Method Post -UseDefaultCredentials -ContentType application/json -Uri $Uri -Body $body_internal

   echo $body_internal


}

echo ''

 #Invoke-RestMethod -Uri "http://w4bibuild1701:8080/tfs/DefaultCollection/SIA/_apis/build/definitions?api-version=2.0" -ContentType "text/plain" -Method Post -Body $body 