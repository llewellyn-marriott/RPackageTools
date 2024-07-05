# R Package Tools

PowerShell module to mirror R repository and set authenticode signatures on files within packages.

## Motivation

If you are a sysadmin using AppLocker for application whitelisting and have developers who use R, you may have found that their R packages contain DLLs.

Because AppLocker doesn't provide a way to exclude based on executing application your options are:

1. Create hash rules for every DLL inside every version of every package your devs want to use.
2. Exclude the directory where R packages are installed (very insecure since this directory is usually user writeable).
3. Sign the DLLs with your own code signing certificate and exclude that.

I developed the functions in this PowerShell module so that contents of R packages could be automatically signed, while also allowing a review and approval process so security personnel can make sure no malicious packages are being used by developers. Thus allowing developers to specify what packages they require while helping protect against supply chain attacks.

## Implementation

An [example implementation](./Example/AzureDevOps/README.md) that uses Azure DevOps and a storage account running as a static site is provided in the examples directory. This provides a simple and cheap way to maintain an internal package mirror with signed contents.
