data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_dir = "./../code/" 
  output_path = "nametest.zip"
}