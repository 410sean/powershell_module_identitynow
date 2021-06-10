function Export-IdentityNowConfig {
    <#
.SYNOPSIS
    Export IdentityNow configuration items

.DESCRIPTION
    Exports IdentityNow Access Profiles, APIClients, Applications, Cert Campaigns, Email Templates, Governance Groups, Identity Attributes, Identity Profiles, OAuth API Clients, Roles, Rules, Sources, Transforms, VAClusters, to files to make comparions or check into source control

.PARAMETER path
    (Required - string) folder path to export configuration items

.PARAMETER Items
    (optional - custom list array) if not specified, all items will be assumed, if specified you can list all items to be exported

.EXAMPLE
    Export-IdentityNowConfig -path 'c:\repos\IDN-Prod'

.EXAMPLE
    Export-IdentityNowConfig -path 'c:\repos\IDN-Prod' -Items Rules,Roles

.EXAMPLE
    Set-IdentityNowOrg myCompanyProd
    Export-IdentityNowConfig -path "C:\repos\IDNConfig\$((Get-IdentityNowOrg).'Organisation Name')" 
    Set-IdentityNowOrg myCompanySandbox
    Export-IdentityNowConfig -path "C:\repos\IDNConfig\$((Get-IdentityNowOrg).'Organisation Name')"

.LINK
    http://darrenjrobinson.com/sailpoint-identitynow

#>

    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.IO.FileInfo]$path,
        [ValidateSet('AccessProfile', 'APIClients', 'Applications', 'CertCampaigns', 'EmailTemplates', 'GovernanceGroups', 'IdentityAttributes', 'IdentityProfiles', 'OAuthAPIClients', 'Roles', 'Rules', 'Sources', 'Transforms', 'VAClusters')]
        [string[]]$Items
    )
    if ($path.mode -ne 'd----') { Write-Error "provided path is not a directory: $path"; break }
    if ($null -eq $Items) {
        $Items = @('AccessProfile', 'APIClients', 'Applications', 'CertCampaigns', 'EmailTemplates', 'GovernanceGroups', 'IdentityAttributes', 'IdentityProfiles', 'OAuthAPIClients', 'Roles', 'Rules', 'Sources', 'Transforms', 'VAClusters')
    }
    if ($path.fullname.lastindexof('\') -eq $path.fullname.length - 1) { [System.IO.FileInfo]$path = $path.FullName.Substring(0, $path.FullName.length - 1) }
    if ($Items -contains 'AccessProfile') {
        write-progress -activity 'AccessProfile'
        $AccessProfile = Get-IdentityNowAccessProfile
        $AccessProfile | convertto-json -depth 10 | Set-Content "$($path.FullName)\AccessProfile.json"
    }
    if ($Items -contains 'APIClients') {
        write-progress -activity 'APIClients'
        $APIClients = Get-IdentityNowAPIClient
        $detailedAPIClients = @()
        foreach ($client in $APIClients) {
            $client = Get-IdentityNowAPIClient -ID $client.id
            $detailedAPIClients += $client
        }
        $detailedAPIClients | convertto-json -depth 10 | Set-Content "$($path.FullName)\APIClients.json"
    }
    if ($Items -contains 'Applications') {
        write-progress -activity 'Applications'
        $Applications = Get-IdentityNowApplication
        $detailedApplications = @()
        foreach ($app in $Applications) {
            $app = Get-IdentityNowApplication -appID $app.id
            $detailedApplications += $app
        }
        $detailedApplications | convertto-json -depth 10 | Set-Content "$($path.FullName)\Applications.json"
    }
    if ($Items -contains 'CertCampaigns') {
        write-progress -activity 'CertCampaigns'
        $CertCampaigns = Get-IdentityNowCertCampaign
        $CertCampaigns | convertto-json -depth 10 | Set-Content "$($path.FullName)\CertCampaigns.json"
    }
    if ($Items -contains 'EmailTemplates') {
        write-progress -activity 'EmailTemplates'
        $EmailTemplates = Get-IdentityNowEmailTemplate
        $EmailTemplates | convertto-json -depth 10 | Set-Content "$($path.FullName)\EmailTemplates.json"
    }
    if ($Items -contains 'GovernanceGroups') {
        write-progress -activity 'GovernanceGroups'
        $GovernanceGroups = Get-IdentityNowGovernanceGroup
        $GovernanceGroups | convertto-json -depth 10 | Set-Content "$($path.FullName)\GovernanceGroups.json"
    }
    if ($Items -contains 'IdentityAttributes') {
        write-progress -activity 'IdentityAttributes'
        $IdentityAttributes = Get-IdentityNowIdentityAttribute
        $IdentityAttributes | convertto-json -depth 10 | Set-Content "$($path.FullName)\IdentityAttributes.json"
    }
    if ($Items -contains 'IdentityProfiles') {
        write-progress -activity 'IdentityProfiles'
        $idp = Get-IdentityNowProfile
        $detailedIDP = @()
        foreach ($profile in $idp) {
            $profile = Get-IdentityNowProfile -ID $profile.id
            $detailedIDP += $profile
        }
        $detailedIDP | convertto-json -depth 10 | Set-Content "$($path.FullName)\IdentityProfiles.json"
    }
    if ($Items -contains 'OauthAPIClients') {
        write-progress -activity 'OauthAPIClients'
        $OauthAPIClients = Get-IdentityNowOAuthAPIClient
        $OauthAPIClients | convertto-json -depth 10 | Set-Content "$($path.FullName)\OAuthAPIClients.json"
    }
    if ($Items -contains 'Roles') {
        write-progress -activity 'Roles'
        $roles = Get-IdentityNowRole
        $detailedroles = @()
        foreach ($role in $roles) {
            $temp = Get-IdentityNowRole -roleID $role.id
            $role | Add-Member -NotePropertyName selector -NotePropertyValue $temp.selector -Force
            $role | Add-Member -NotePropertyName approvalSchemes -NotePropertyValue $temp.approvalSchemes -Force
            $role | Add-Member -NotePropertyName deniedCommentsRequired -NotePropertyValue $temp.deniedCommentsRequired -Force
            $role | Add-Member -NotePropertyName identityCount -NotePropertyValue $temp.identityCount -Force
            $role | Add-Member -NotePropertyName revokeRequestApprovalSchemes -NotePropertyValue $temp.revokeRequestApprovalSchemes -Force
            $detailedroles += $role
        }
        $detailedroles | convertto-json -depth 10 | Set-Content "$($path.FullName)\Roles.json"
    }
    if ($Items -contains 'Rules') {
        write-progress -activity 'Rules'
        $rules = Get-IdentityNowRule
        $rules | convertto-json -depth 10 | Set-Content "$($path.FullName)\Rules.json"
    }
    if ($Items -contains 'Sources') {
        write-progress -activity 'Sources'
        $sources = Get-IdentityNowSource
        $detailedsources = @()
        foreach ($source in $sources) {
            Write-Verbose "$($source.name)($($source.id))"
            write-progress -activity "Sources" -status "$($source.name)($($source.id)) details"
            do {
                $temp = $null
                $temp = Get-IdentityNowSource -sourceID $source.id
                Start-Sleep -Milliseconds 100
            }until($null -ne $temp)
            $source = $temp
            Write-Verbose "getting account profiles"
            write-progress -activity "Sources" -status "$($source.name)($($source.id)) account profiles"
            $source | Add-Member -NotePropertyName 'accountProfiles' -NotePropertyValue (Get-IdentityNowSource -sourceID $source.id -accountProfiles) -Force
            Write-Verbose "getting schema"
            write-progress -activity "Sources" -status "$($source.name)($($source.id)) schema"
            $source | Add-Member -NotePropertyName 'Schema' -NotePropertyValue (Get-IdentityNowSourceSchema -sourceID $source.id) -Force
            $detailedsources += $source
        }
        $detailedsources | convertto-json -depth 10 | Set-Content "$($path.FullName)\Sources.json"
    }    
    if ($Items -contains 'Transforms') {
        write-progress -activity 'Transforms'
        $transforms = Get-IdentityNowTransform
        $transforms | convertto-json -depth 10 | Set-Content "$($path.FullName)\Transforms.json"
    }
    if ($Items -contains 'VAClusters') {
        write-progress -activity 'VAClusters'
        $VAClusters = Get-IdentityNowVACluster
        $VAClusters | convertto-json -depth 10 | Set-Content "$($path.FullName)\VAClusters.json"
    }
}
# SIG # Begin signature block
# MIINSwYJKoZIhvcNAQcCoIINPDCCDTgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUd8BKhbTZkGIWZXyoIvQXZTNM
# noegggqNMIIFMDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0B
# AQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAwWjByMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQg
# Q29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# +NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6kkPApfmJ
# 1DcZ17aq8JyGpdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0
# sSgmuyRpwsJS8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6s
# cKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4Tz
# rGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg
# 0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgwBgEB/wIB
# ADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYIKwYBBQUH
# AQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYI
# KwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaG
# NGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
# QS5jcmwwTwYDVR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0
# dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYE
# FFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
# IZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2qB1dHC06
# GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4QpO4/cY5j
# DhNLrddfRHnzNhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEpKBo6cSgC
# PC6Ro8AlEeKcFEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/DmZAwlCEIy
# sjaKJAL+L3J+HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4Gb
# T8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHvMIIFVTCC
# BD2gAwIBAgIQDOzRdXezgbkTF+1Qo8ZgrzANBgkqhkiG9w0BAQsFADByMQswCQYD
# VQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGln
# aWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29k
# ZSBTaWduaW5nIENBMB4XDTIwMDYxNDAwMDAwMFoXDTIzMDYxOTEyMDAwMFowgZEx
# CzAJBgNVBAYTAkFVMRgwFgYDVQQIEw9OZXcgU291dGggV2FsZXMxFDASBgNVBAcT
# C0NoZXJyeWJyb29rMRowGAYDVQQKExFEYXJyZW4gSiBSb2JpbnNvbjEaMBgGA1UE
# CxMRRGFycmVuIEogUm9iaW5zb24xGjAYBgNVBAMTEURhcnJlbiBKIFJvYmluc29u
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwj7PLmjkknFA0MIbRPwc
# T1JwU/xUZ6UFMy6AUyltGEigMVGxFEXoVybjQXwI9hhpzDh2gdxL3W8V5dTXyzqN
# 8LUXa6NODjIzh+egJf/fkXOgzWOPD5fToL7mm4JWofuaAwv2DmI2UtgvQGwRhkUx
# Y3hh0+MNDSyz28cqExf8H6mTTcuafgu/Nt4A0ddjr1hYBHU4g51ZJ96YcRsvMZSu
# 8qycBUNEp8/EZJxBUmqCp7mKi72jojkhu+6ujOPi2xgG8IWE6GqlmuMVhRSUvF7F
# 9PreiwPtGim92RG9Rsn8kg1tkxX/1dUYbjOIgXOmE1FAo/QU6nKVioJMNpNsVEBz
# /QIDAQABo4IBxTCCAcEwHwYDVR0jBBgwFoAUWsS5eyoKo6XqcQPAYPkt9mV1Dlgw
# HQYDVR0OBBYEFOh6QLkkiXXHi1nqeGozeiSEHADoMA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzB3BgNVHR8EcDBuMDWgM6Axhi9odHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLWNzLWcxLmNybDA1oDOgMYYvaHR0
# cDovL2NybDQuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1nMS5jcmwwTAYD
# VR0gBEUwQzA3BglghkgBhv1sAwEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cu
# ZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBBAEwgYQGCCsGAQUFBwEBBHgwdjAkBggr
# BgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME4GCCsGAQUFBzAChkJo
# dHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNzdXJlZElE
# Q29kZVNpZ25pbmdDQS5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOC
# AQEANWoHDjN7Hg9QrOaZx0V8MK4c4nkYBeFDCYAyP/SqwYeAtKPA7F72mvmJV6E3
# YZnilv8b+YvZpFTZrw98GtwCnuQjcIj3OZMfepQuwV1n3S6GO3o30xpKGu6h0d4L
# rJkIbmVvi3RZr7U8ruHqnI4TgbYaCWKdwfLb/CUffaUsRX7BOguFRnYShwJmZAzI
# mgBx2r2vWcZePlKH/k7kupUAWSY8PF8O+lvdwzVPSVDW+PoTqfI4q9au/0U77UN0
# Fq/ohMyQ/CUX731xeC6Rb5TjlmDhdthFP3Iho1FX0GIu55Py5x84qW+Ou+OytQcA
# FZx22DA8dAUbS3P7OIPamcU68TGCAigwggIkAgEBMIGGMHIxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25p
# bmcgQ0ECEAzs0XV3s4G5ExftUKPGYK8wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcC
# AQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYB
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFPG9Zddga1hR
# W7Ih+m0QIZN8ZhXPMA0GCSqGSIb3DQEBAQUABIIBAC2WNcY0MfDbhfJMhi3/dtSq
# kyiJAdzd4Oxeq8AeZYM0K6PnveSF02Y83mcu+5Ptm4HCBU1iHs0NVPs0fsrtC3ib
# 4Qz1k2Y9OSFdZD5dSYe6cs4CwCh/5g73dSytebDSjzKRC3YgkNFbDgndLecSIXYg
# 1/0MnYEJbIcJXCQpOEdKNZ2Ty/Td3Q9dgNH2EsxVJg5CDrM+a0fzymRUfOdVc1UN
# HjOfnC8dPMXmCWI3rtrJh3PwCLAt+ljQakHXKGFDui+lOspSLZxHcqynIP3TW577
# c5Y69PNF0L3NLHEvX8zaTJKmqiKktclSerJT2U23aZp2ogdwpwLzZxdAohxj7so=
# SIG # End signature block