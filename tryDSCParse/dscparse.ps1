function dscparse {
    param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]        
        $FullName
    )

    Process {
        #$content=gc -Raw $FullName
        #$ast=[scriptblock]::Create($content).ast
        #$ast=$null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($FullName, $tokens,$errors)

        $predicate = {
            $args[0] -is [System.Management.Automation.Language.DynamicKeywordStatementAst] -and
            $args[0].CommandElements[2] -is [System.Management.Automation.Language.HashtableAst]
        }

        $resources = $ast.FindAll($predicate, $true)

        foreach ($resource in $resources) {
            $DependsOn = $resource.CommandElements[2].KeyValuePairs |
                Where { $_.Item1.Extent.Text -eq 'DependsOn' } |
                ForEach { $_.Item2.Extent.Text }
    
            [pscustomobject] @{
                Type      = $resource.CommandElements[0].Extent.Text
                Name      = $resource.CommandElements[1].Extent.Text
                DependsOn = $resource.CommandElements[2].KeyValuePairs |
                            Where { $_.Item1.Extent.Text -eq 'DependsOn' } |
                            ForEach { $_.Item2.Extent.Text }
            }
        }
    }
}