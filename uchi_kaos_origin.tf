##########################################################################
# sa create zone start                                                   #
##########################################################################

######### Service Accounts for desc analyts&dataengineer personal use 
locals {
   desc-dupf-anls-dtrs = {
    "desc-dupf-anl01" = "sa-desc-dupf-anl-dtr01"
    "desc-dupf-anl02" = "sa-desc-dupf-anl-dtr02"
    "desc-dupf-anl03" = "sa-desc-dupf-anl-dtr03"
    "desc-dupf-anl04" = "sa-desc-dupf-anl-dtr04"
    "desc-dupf-anl05" = "sa-desc-dupf-anl-dtr05"
    "desc-dupf-anl06" = "sa-desc-dupf-anl-dtr06"
    "desc-dupf-anl07" = "sa-desc-dupf-anl-dtr07"
    "desc-dupf-anl08" = "sa-desc-dupf-anl-dtr08"
    "desc-dupf-anl09" = "sa-desc-dupf-anl-dtr09"
   }
}

############ Service Accounts for dh analyts personal use ############
locals {
   dh-dupf-anls = {
    "dh-dupf-anl01" = "sa-dh-dupf-anl01"
    "dh-dupf-anl02" = "sa-dh-dupf-anl02"
    "dh-dupf-anl03" = "sa-dh-dupf-anl03"
   }
}


######### Service Accounts for dh dataengineer personal use ##########
locals {
   dh-dupf-dtrs = {
    "dh-dupf-dtr01" = "sa-dh-dupf-dtr01"
    "dh-dupf-dtr02" = "sa-dh-dupf-dtr02"
    "dh-dupf-dtr03" = "sa-dh-dupf-dtr03"
   }
}

##################### Service Accounts for VM ########################
locals {
  sa-airflow = {
    "vm01" = "sa-airflow"
  }
}

locals {
  sa-gcr = {
    "vm02" = "sa-gcr"
  }
}

locals {
  sa-vm = merge(
    local.sa-airflow,
    local.sa-gcr
  )
}

############
############ Create Service Accounts
############

locals {
  all_sa = merge(
    local.desc-dupf-anls-dtrs,
    local.dh-dupf-anls,
    local.dh-dupf-dtrs,
    local.sa-vm
  )
}

resource "google_service_account" "sa" {
  project = var.project
  for_each = local.all_sa
  account_id   = each.value
}

##########################################################################
# sa create zone end                                                     #
##########################################################################

##########################################################################
#  roles attach zone start                                               #
##########################################################################

###############  sa-desc-dupf-anl-dtr start  ################
locals {
  desc-dupf-anls-dtrs_roles = {
    "vi" = "roles/viewer"
    "bj" = "roles/bigquery.jobUser"
    "br" = "roles/bigquery.readSessionUser"
  }
}

locals {
  desc-dupf-anls-dtrs_roles_members = [
    for pair in setproduct(keys(local.desc-dupf-anls-dtrs), values(local.desc-dupf-anls-dtrs_roles)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      role    = pair[1]
    }
  ]
}
###############  sa-desc-dupf-anl-dtr end  ################

############### sa-dh-dupf-dtr start  ################
locals {
  dh-dupf-anls_roles = {
    "bj" = "roles/bigquery.jobUser"
    "br" = "roles/bigquery.readSessionUser"
  }
}

locals {
  dh-dupf-anls_roles_members = [
    for pair in setproduct(keys(local.dh-dupf-anls), values(local.dh-dupf-anls_roles)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      role    = pair[1]
    }
  ]
}
############### sa-dh-dupf-dtr end  ################

############### data-transfers start  ################
locals {
  desc-data-transfers_group = {
    "desc-data-transfers" = "desc-du-data-transfers-gcp_my@dena.jp"
  }
}

locals {
  dh-data-transfers_group = {
    "dh-data-transfers" = "dh-du-data-transfers-gcp_my@dena.jp"
  }
}

locals {
  data-transfers_group = merge(
    local.desc-data-transfers_group,
    local.dh-data-transfers_group
  )
}

locals {
  data-transfers_group_roles = {
    "vi" = "roles/viewer"
    "sv" = "roles/storage.objectViewer"
  }
}

locals {
  data-transfers_group_roles_members = [
    for pair in setproduct(keys(local.data-transfers_group), values(local.data-transfers_group_roles)) : {
      username = pair[0]
      account = local.data-transfers_group[pair[0]]
      role    = pair[1]
    }
  ]
}
############### data-transfers end  ################

############### data-analysts start ################
locals {
  desc-data-analysts_group = {
    "desc-data-analysts" = "desc-du-data-analysts-gcp_my@dena.jp"
  }
}

locals {
  dh-data-analysts_group = {
    "dh-data-analysts" = "dh-du-data-analysts-gcp_my@dena.jp"
  }
}

locals {
  data-analysts_group = merge(
    local.desc-data-analysts_group,
    local.dh-data-analysts_group
  )
}

locals {
  data-analysts_group_roles = {
    "vi" = "roles/viewer"
    "bj" = "roles/bigquery.jobUser"
    "br" = "roles/bigquery.readSessionUser"
  }
}

locals {
  data-analysts_group_roles_members = [
    for pair in setproduct(keys(local.data-analysts_group), values(local.data-analysts_group_roles)) : {
      username = pair[0]
      account = local.data-analysts_group[pair[0]]
      role    = pair[1]
    }
  ]
}
############### data-analysts end ################

############### sa-vm start  ################
locals {
  sa-airflow_roles = {
     "cw" = "roles/composer.worker"
     "sa" = "roles/storage.admin"
     "ba" = "roles/bigquery.admin"
  }
}

locals {
  sa-airflow_roles_members = [
    for pair in setproduct(keys(local.sa-airflow), values(local.sa-airflow_roles)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      role    = pair[1]
    }
  ]
}

locals {
  sa-gcr_roles = {
    "vi" = "roles/viewer"
    "cs" = "roles/containerregistry.ServiceAgent"
  }
}

locals {
  sa-gcr_roles_members = [
    for pair in setproduct(keys(local.sa-gcr), values(local.sa-gcr_roles)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      role    = pair[1]
    }
  ]
}

locals {
  sa-vm_roles_members = concat(
    local.sa-airflow_roles_members,
    local.sa-gcr_roles_members
  )
}
############## sa-vm end  ################


############
############ Attach roles
############

locals {
  all_roles_members = concat(
    local.desc-dupf-anls-dtrs_roles_members,
    local.dh-dupf-anls_roles_members,
    local.data-transfers_group_roles_members,
    local.data-analysts_group_roles_members,
    local.sa-vm_roles_members
  )
}

resource "google_project_iam_member" "all" {
  project = var.project
  for_each = {
    for d in local.all_roles_members : "${d.username} ${d.role}" => d
  }
  role   = each.value.role
  member = each.value.account 
  
  depends_on = [google_service_account.sa]
}

##########################################################################
#  roles attach zone end                                                 #
##########################################################################


##########################################################################
#  bigquery_dataset roles attach zone start                              #
##########################################################################

locals {
   desc_allow_bigquery_datasets = {
    "desc01" = "created at 2021/07"
    "dh01" = "created at 2021/07"
    "master01" = "created at 2021/07"
    "sys_master" = "created at 2021/07"
    "integrated01" = "created at 2021/07"
    "temp" = "created at 2021/07"
    }
}

locals {
   dh_allow_bigquery_datasets = {
    "integrated01" = "created at 2021/07"
    }
}

locals {
  desc-data-analysts_dataset_members = [
    for pair in setproduct(keys(local.desc-data-analysts_group), keys(local.desc_allow_bigquery_datasets)) : {
      username = pair[0]
      account = local.desc-data-analysts_group[pair[0]]
      dataset_id = pair[1]
    }
  ]
}

locals {
  sa-desc-dupf-anls-dtrs_dataset_members = [
    for pair in setproduct(keys(local.desc-dupf-anls-dtrs), keys(local.desc_allow_bigquery_datasets)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      dataset_id = pair[1]
    }
  ]
}

locals {
  dh-data-analysts_dataset_members = [
    for pair in setproduct(keys(local.dh-data-analysts_group), keys(local.dh_allow_bigquery_datasets)) : {
      username = pair[0]
      account = local.dh-data-analysts_group[pair[0]]
      dataset_id = pair[1]
    }
  ]
}

locals {
  sa-dh-dupf-anls_dataset_members = [
    for pair in setproduct(keys(local.dh-dupf-anls), keys(local.dh_allow_bigquery_datasets)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      dataset_id = pair[1]
    }
  ]
}

############
############ Attach roles
############

locals {
  all_dataset_members = concat(
    local.desc-data-analysts_dataset_members,
    local.sa-desc-dupf-anls-dtrs_dataset_members,
    local.dh-data-analysts_dataset_members,
    local.sa-dh-dupf-anls_dataset_members
  )
}

resource "google_bigquery_dataset_iam_member" "anls" {
  project = var.project
  for_each = {
    for d in local.all_dataset_members : "${d.username} ${d.dataset_id}" => d
  }
  dataset_id = each.value.dataset_id
  role       = "roles/bigquery.admin"
  member     = each.value.account 
  
  depends_on = [google_service_account.sa]
}

##########################################################################
#  bigquery_dataset roles attach zone end                                #
##########################################################################


##########################################################################
#  storage roles attach zone start                                       #
##########################################################################

locals {
   desc_allow_storage = {
    "dupf-desc-data" = "created at 2021/07"
    }
}

locals {
   dh_allow_storage = {
    "dupf-dh-data" = "created at 2021/07"
    }
}

locals {
  desc-data-transfers_stotage_members = [
    for pair in setproduct(keys(local.desc-data-transfers_group), keys(local.desc_allow_storage)) : {
      username = pair[0]
      account = local.desc-data-transfers_group[pair[0]]
      bucket = pair[1]
    }
  ]
}

locals {
  sa-desc-dupf-anls-dtrs_storage_members = [
    for pair in setproduct(keys(local.desc-dupf-anls-dtrs), keys(local.desc_allow_storage)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      bucket = pair[1]
    }
  ]
}

locals {
  dh-data-transfers_storage_members = [
    for pair in setproduct(keys(local.dh-data-transfers_group), keys(local.dh_allow_storage)) : {
      username = pair[0]
      account = local.dh-data-transfers_group[pair[0]]
      bucket = pair[1]
    }
  ]
}

locals {
  sa-dh-dupf-dtrs_storage_members = [
    for pair in setproduct(keys(local.dh-dupf-dtrs), keys(local.dh_allow_storage)) : {
      username = pair[0]
      account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      bucket = pair[1]
    }
  ]
}

############
############ Attach roles
############

locals {
  all_storage_members = concat(
    local.desc-data-transfers_stotage_members,
    local.sa-desc-dupf-anls-dtrs_storage_members,
    local.dh-data-transfers_storage_members,
    local.sa-dh-dupf-dtrs_storage_members
  )
}

resource "google_storage_bucket_iam_member" "dtrs" {
  for_each = {
    for d in local.all_storage_members : "${d.username} ${d.bucket}" => d
  }
  bucket = each.value.bucket
  role       = "roles/storage.admin"
  member     = each.value.account 

  depends_on = [google_service_account.sa]

}

##########################################################################
#  storage roles attach zone end                                         #
##########################################################################