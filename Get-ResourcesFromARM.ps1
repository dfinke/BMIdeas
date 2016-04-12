function Get-ResourcesFromARM {
    param(
        [Parameter(Mandatory=$true)]
        $fullname
    )

    function clean-dependson {
        param($p)
        
        ($p -split ',')[0] -replace "'|\[|\(|resourceid",''        
    }

    $r=(gc $fullname | ConvertFrom-Json).resources

    $r  |% {    
        "$($_.type) [$(clean-dependson $_.dependson)]"
    
        $_.resources | % {
            "`t$($_.type) [$(clean-dependson $_.dependson)]"        
        }
    
        ""
    }
}