output "apiGatewayInvokeURl" {
    description = "Api EndPoint Url"
    value = aws_api_gateway_deployment.deployment.invoke_url
}

output "apiPath" {
    description = "Api EndPoint Path"
    value = aws_api_gateway_resource.root.path_part
}