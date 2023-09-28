#### Example
```terraform
module "test-resource-server" {
  source     = "path/to/resource-server"
  name       = "test/dev"
  identifier = "https://api-dev.example.org"
  scopes = {
    "message:read"  = "read messages"
    "message:write" = "write messages"
    "message:admin" = "admin messages"
  }
  roles = [
    { name = "admin", description = "admin user for test application", scopes = ["message:admin"] }
  ]
}
```