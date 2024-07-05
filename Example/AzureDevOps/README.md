# Azure DevOps with storage account

This is an example method of how to use this module with Azure DevOps and a storage account.

## DevOps Setup

* Create a storage account and enable static web hosting.
* Create an Azure Service connection in DevOps.
* Create a new repository and add the files in this examples folder.
* In DevOps, under Pipelines > Library, create a new library called `RPackageVariableGroup` with the following secrets:
  * serviceConnection: Name of the service connection used to connect to your Azure blob storage
  * certificateSecret: Secret to decrypt your code signing certificate.
  * subscriptionName: Name of the subscription the storage account is in.
  * storageAccountDir: Base path used for the repository. e.g. `/production`.
  * storageAccountName: Name of the storage account the repository will be hosted on.
* Create a secure file in the library called `CodeSigningCertificate.pfx`.
* Create a new pipeline using the [azurePipelines.yml](./azurePipelines.yml) file.

## Client setup

Set your R repository on your client to be the storage account static site URL.

## Updating packages

When ever you update Packages.psd1 the pipeline should fire and update the repository.