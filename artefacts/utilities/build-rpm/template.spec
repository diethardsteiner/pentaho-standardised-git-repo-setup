# This is a sample spec file
 
%define _topdir     ${PSGRS_RPM_BUILD_HOME}
%define name        ${PSGRS_PROJECT_NAME}
%define release     1 <-- [OPEN has to be replaced at run-time]
%define version     1.01 <-- [OPEN has to be replaced at run-time]
%define buildroot   %{_topdir}/%{name}-%{version}-root
 
BuildRoot:      %{buildroot}
Summary:        ${PSGRS_RPM_SUMMARY}
License:        GPL
Name:           %{name}
Version:        %{version}
Release:        %{release}
Group:          Development/Tools
Requires:       bash
Source:         %{name}-%{version}.tgz
 
%description
${PSGRS_RPM_DESCRIPTION}

%global debug_package %{nil}


# Prep is used to set up the environment for building the rpm package
# Expansion of source tar balls are done in this section
%prep
%setup

# Used to compile and to build the source
%build
# Normally this part would be full of fancy compile stuff. Make this, make that.
# We simple folks, we just want to copy some files out of a tar.gz.
# so we pass this section with nothing done...

# The installation.
# We actually just put all our install files into a directory structure that
# mimics a server directory structure here
# Normally using the “make install”
# command, it normally places the files
# where they need to go. You can also copy the files, as we do here...
%install
# target directory of install is %{_topdir}/BUILD
# create the directory structure that matches the final one 
# where packages will be installed

# First we make sure we start clean
rm -r %{buildroot}

# Then we create the directories where the files go
# don't worry if the directories exist on your target systems, rpm
# creates if necessary
mkdir -p %{buildroot}/opt/psgrs


# install -p -m 755 %{_topdir}/BUILD/%{name}-%{version}/* %{buildroot}/opt/psgrs
cp %{_topdir}/BUILD/%{name}-%{version}/* %{buildroot}/opt/psgrs

%clean
rm -rf %{buildroot}


%post
echo "Installed %{name} scripts to /opt/psgrs"
# Contains a list of the files that are part of the package
# See useful directives such as attr here: http://www.rpm.org/max-rpm-snapshot/s1-rpm-specref-files-list-directives.html

# list files or directories that should be bundled into the RPM
# optionally set permissions
%files
/opt/psgrs
# set permissions
#%defattr(-,root,root)
#/usr/local/bin/wget

%changelog

# add manual
#%doc %attr(0444,root,root) /usr/local/share/man/man1/wget.1
