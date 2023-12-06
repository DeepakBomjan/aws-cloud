## Decode Encoded message

### Error message
```
You are not authorized to perform this operation. User: arn:aws:iam::930106672181:user/cloud_user is not authorized to perform: ec2:RequestSpotFleet on resource: arn:aws:ec2:us-east-1::image/ami-0fa1ca9559f1892ec with an explicit deny in a service control policy. Encoded authorization failure message: c5pQw8J0-ZNfDhyaMgMlubeWB8Dj7mP1eUtnKZ9U-T-X2q_cEaER-0_U4rANkyE-5bSBWhoGHd9jFT3ff5NLYcLyzZ5i0rdiWb7tsfZrg9IVP0k26whECTiJeQTuoWuxgoHcg0jhrjGFwYJ-gTeyKnR451D3aaw7uoCAIiOwEEaGglewcVIjz1gjxjd5UK9fbgVpXPb37kkq10b8Tdf9RAmLWPKGt_JGmhqJRWpsXlNXlGtuxvzFScIQbpOa6T1hzi8Cu3Iue2-
```
### Command to decode

### Check if AWS sts is available
```
aws sts get-caller-identity
```

```
aws sts decode-authorization-message --encoded-message "<Encoded message>" | jq -r .DecodedMessage | jq
```