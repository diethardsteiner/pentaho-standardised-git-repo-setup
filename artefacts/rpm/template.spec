# This is a sample spec file
 
%define _topdir     /home/dsteiner/psgrs
%define name        psgrs
%define release     1
%define version     1.01
%define buildroot   %{_topdir}/%{name}-%{version}-root
 
BuildRoot:      %{buildroot}
Summary:        Pentaho Standardised Git Repo Setup
License:        GPL
Name:           %{name}
Version:        %{version}
Release:        %{release}
Source:         %{name}-%{version}.tgz
Prefix:         /usr
Group:          Development/Tools
 
%description
Framework to create standardised git directory setup for Pentaho projects

%global debug_package %{nil}

#%prep
# call macro to unpack tar file 
#%setup -q
 
#%build
 
%install
# target directory of install is <parent-folder>/BUILD
# create the directory structure that matches the final one 
# where packages will be installed
mkdir -p %{buildroot}/opt/psgrs
install -p -m 755 %{SOURCE0} %{buildroot}/opt/psgrs
# list files or directories that should be bundled into the RPM
# optionally set permissions
%files
/opt/psgrs
# set permissions
#%defattr(-,root,root)
#/usr/local/bin/wget
 
# add manual
#%doc %attr(0444,root,root) /usr/local/share/man/man1/wget.1
