output "apiGatewayInvokeUrl" {
  value = module.apiGateway.apiGatewayInvokeURl
  description = "Api EndPoint URL"
}

output "apiPath" {
    description = "Api EndPoint Path"
    value = join("/",[module.apiGateway.apiGatewayInvokeURl,module.apiGateway.apiPath])
}