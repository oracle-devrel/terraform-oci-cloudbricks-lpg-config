# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# lpgconfig.tf 
#
# Purpose: The following script adds the extra LPG Routes using project ortu implementation through null resources
# Documentation: https://pypi.org/project/ortu/ 


resource "null_resource" "enable_virtual_env" {
  triggers = {
    to_lpg_ocid     = local.to_lpg_ocid
    from_cidr_block = local.from_vcn_cidr
    to_rt_ocid      = local.to_rt_ocid
    from_lpg_ocid   = local.from_lpg_ocid
    to_cidr_block   = local.to_vcn_cidr
    from_rt_ocid    = local.from_rt_ocid
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<-EOT
    python3 -m venv lpg_routes_config
    source lpg_routes_config/bin/activate
    pip3 install --upgrade pip
    pip3 install ortu 
    EOT  
  }

}

resource "null_resource" "to_route_table_update" {
  depends_on = [
    null_resource.enable_virtual_env
  ]


  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<-EOT
    source lpg_routes_config/bin/activate
    ortu --rt-ocid ${self.triggers.to_rt_ocid} --cidr ${self.triggers.from_cidr_block} --ne-ocid ${self.triggers.to_lpg_ocid}
    sleep 15
    EOT
  }
}

resource "null_resource" "from_route_table_update" {
  depends_on = [
    null_resource.enable_virtual_env
  ]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<-EOT
    source lpg_routes_config/bin/activate
    ortu --rt-ocid ${self.triggers.from_rt_ocid} --cidr ${self.triggers.to_cidr_block} --ne-ocid ${self.triggers.from_lpg_ocid}
    sleep 15
    EOT
  }
}