zip -r $1.zip $1.py
lambda_name=$(echo "$1" | tr '_' '-')
aws lambda update-function-code --function-name $lambda_name --zip-file fileb://$1.zip