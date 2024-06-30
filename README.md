# friendly-octo-garbanzo
Important!
The modules used were written with Terraform in mind and not with OpenTofu.
Terraform cares more about backwards compatability.
If you will use newer versions of OpenTofu `tofu init` might fail.
There are three lines in the VPC module refering to "vpc-classic" that will appear in the error, delete them from the module and proceed.