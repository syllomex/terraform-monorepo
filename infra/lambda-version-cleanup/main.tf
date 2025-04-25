resource "terraform_data" "clean_old_lambda_versions" {
  triggers_replace = var.lambda_version

  provisioner "local-exec" {
    command = <<EOT
      aws lambda list-versions-by-function \
        --region ${var.region} \
        --profile ${var.profile} \
        --function-name ${var.lambda_function_name} \
        --query "Versions[?Version!='${var.lambda_version}' && Version!='\$LATEST'].Version" \
        --output text | tr '\t' '\n' | xargs -n 1 -I {} aws lambda delete-function \
        --region ${var.region} \
        --profile ${var.profile} \
        --function-name ${var.lambda_function_name} \
        --qualifier {}
    EOT
  }
}
