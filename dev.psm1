function GetRepoPath {
    $repoRoot = (get-item $PSScriptRoot).FullName
    return $repoRoot
}

function WritePrompt {
    param (
        [Parameter(Mandatory)]
        [string]$Message
    )
    $val = $(Write-Host $Message -ForegroundColor Magenta -NoNewline; Read-Host)
    return $val
}

function CdToMobile  {
    $path = GetRepoPath
    cd $path
}

function CleanEnvFolders {
    $curDir = Convert-Path .
    CdToMobile
    cd android

    #Delete cached folders
    $gradleFolder = ".gradle"
    $buildFolderPath = "build"
    $appBuildFolderPath = "app\build"
    if(Test-Path $buildFolderPath){
        Remove-Item -Recurse -Force $gradleFolder
    }   
    if(Test-Path $buildFolderPath){
        Remove-Item -Recurse -Force $buildFolderPath
    }   
    if(Test-Path $appBuildFolderPath){
        Remove-Item -Recurse -Force $appBuildFolderPath
    }    

    ./gradlew clean

    cd $curDir
}

function InvokeInitAndroid {
    $curDir = Convert-Path .

    CdToMobile

    #Do git pull
    git pull

    #Clean environment
    CleanEnvFolders 

    #Install NPM dependencies
    yarn upgrade

    #Compile and install app
    yarn android

    cd $curDir
}

Set-Alias -Name cdmobile -Value CdToMobile
Set-Alias -Name cleanAndroid -Value CleanEnvFolders @args
Set-Alias -Name initAndroid -Value InvokeInitAndroid @args

Export-ModuleMember -Function * -Alias *
Write-Host 'Mobile Dev Module Imported!' -ForegroundColor Yellow -BackgroundColor DarkGreen