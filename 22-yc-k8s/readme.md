Set-Variable -Name "SA_NAME" -Value "mycloud-sa"
Set-Variable -Name "ZONE_ID" -Value "ru-central1-b"
Set-Variable -Name "NET_NAME" -Value "$(yc vpc network list --format=json | jq -r .[0].name)"
Set-Variable -Name "SUBNET_NAME" -Value "$NET_NAME-$ZONE_ID"

$env:TF_VAR_sa_id=yc iam service-account get --name=$SA_NAME --format=json | jq -r .id
$env:TF_VAR_subnet_id=yc vpc subnet get --name=$SUBNET_NAME --format=json | jq -r .id
$env:TF_VAR_net_id=yc vpc subnet get "$env:TF_VAR_subnet_id" --format=json | jq -r .network_id
$env:TF_VAR_zone_id="$ZONE_ID"