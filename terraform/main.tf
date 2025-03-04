terraform {
  required_providers {
    ionoscloud = {
      source = "registry.terraform.io/ionos-cloud/ionoscloud"
      version = "6.7.0"
    }
  }
}

# test!123$
data "ionoscloud_image" "target" {
  type                  = "HDD"
  cloud_init            = "V1"
  image_alias           = "ubuntu:22.04"
  location              = "us/las"
}
resource "ionoscloud_datacenter" "target" {
    name                  = "Target"
    location              = "us/las"
    description           = "target"
    sec_auth_protection   = false
}
resource "ionoscloud_lan" "target" {
    datacenter_id         = ionoscloud_datacenter.target.id
    public                = true
    name                  = "target"
}
resource "ionoscloud_ipblock" "target" {
    location              = ionoscloud_datacenter.target.location
    size                  = 1
    name                  = "target"
}
resource "ionoscloud_server" "target" {
    name                  = "target"
    datacenter_id         = ionoscloud_datacenter.target.id
    cores                 = 2
    ram                   = 2048
    availability_zone     = "AUTO"
    cpu_family            = "INTEL_XEON"
    image_name            = data.ionoscloud_image.target.name
    image_password        = "test1234"
    type                  = "ENTERPRISE"
    volume {
        name              = "system"
        size              = 25
        disk_type         = "SSD Standard"
        bus               = "VIRTIO"
        availability_zone = "AUTO"
        user_data         = "I2Nsb3VkLWNvbmZpZwpob3N0bmFtZTogZGVmYXVsdC1zZXJ2ZXIKc3NoX3B3YXV0aDogdHJ1ZQpjaHBhc3N3ZDoKICBleHBpcmU6IGZhbHNlCgp1c2VyczoKICAtIG5hbWU6IGRlZmF1bHQKICAtIG5hbWU6IHVidW50dQogICAgcGFzc3dkOiAkNiRaVkJDNmJoeDZRWE1OdHM3JC82YTBhVFU2c3BDQmZWU1FPbHZCbWtKVzd0N0VtWDFJVnJZUEFtamluVlM3RFRRS0E5azBwM0MycDVNWk5zeWxjSjZyQ0VPeEV2bkdyeXQyV1AyTWgvCiAgICBzaGVsbDogL2Jpbi9iYXNoCiAgICBsb2NrX3Bhc3N3ZDogZmFsc2UKICAgIHN1ZG86IEFMTD0oQUxMKSBOT1BBU1NXRDpBTEwKICAgIGdyb3VwczogdXNlcnMsIGFkbWluLCBzdWRvCgpydW5jbWQ6CiAgLSBlY2hvICJyZWdlbmVyYXRpbmcgaG9zdCBrZXlzIgogIC0gcm0gLWYgL2V0Yy9zc2gvc3NoX2hvc3RfKgogIC0gc3NoLWtleWdlbiAtQQogIC0gZWNobyAicmVzdGFydGluZyBzc2hkIgogIC0gc3lzdGVtY3RsIHJlc3RhcnQgc3NoZAoKZGVidWc6IHRydWUKb3V0cHV0OgogIGFsbDogInwgdGVlIC1hIC92YXIvbG9nL2Nsb3VkLWluaXQtZGVidWcubG9nIgpmaW5hbF9tZXNzYWdlOiAiRGVmYXVsdCBWTSBDbG91ZGluaXQgZG9uZSI="
    }
    nic {
        lan               = ionoscloud_lan.target.id
        name              = "system"
        dhcp              = true
        ips               = [ ionoscloud_ipblock.target.ips[0]]
    }
}
