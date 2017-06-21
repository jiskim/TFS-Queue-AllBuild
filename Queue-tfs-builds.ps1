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
