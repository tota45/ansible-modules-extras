#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Get DLL or EXE build version
# Copyright © 2015 Sam Liu <sam.liu@activenetwork.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


DOCUMENTATION = '''
---
module: win_permission
version_added: "1"
short_description: Manages local partition on windows host
description:
     - Manages local partition on windows host
options:
  account:
    description: account name to grant
    required: true
	
  permission:
    description: right to grant
    validateSet: 
      "SeTrustedCredManAccessPrivilege",
      "SeNetworkLogonRight",
      "SeTcbPrivilege",
      "SeMachineAccountPrivilege",
      "SeIncreaseQuotaPrivilege",
      "SeInteractiveLogonRight",
      "SeRemoteInteractiveLogonRight",
      "SeBackupPrivilege",
      "SeChangeNotifyPrivilege",
      "SeSystemtimePrivilege",
      "SeTimeZonePrivilege",
      "SeCreatePagefilePrivilege",
      "SeCreateTokenPrivilege",
      "SeCreateGlobalPrivilege ",
      "SeCreatePermanentPrivilege",
      "SeCreateSymbolicLinkPrivilege",
      "SeDebugPrivilege",
      "SeDenyNetworkLogonRight",
      "SeDenyBatchLogonRight",
      "SeDenyServiceLogonRight",
      "SeDenyInteractiveLogonRight",
      "SeDenyRemoteInteractiveLogonRight",
      "SeEnableDelegationPrivilege", 
      "SeRemoteShutdownPrivilege",
      "SeAuditPrivilege",
      "SeImpersonatePrivilege",
      "SeIncreaseWorkingSetPrivilege",
      "SeIncreaseBasePriorityPrivilege",
      "SeLoadDriverPrivilege",
      "SeLockMemoryPrivilege",
      "SeBatchLogonRight",
      "SeServiceLogonRight",
      "SeSecurityPrivilege",
      "SeRelabelPrivilege",
      "SeSystemEnvironmentPrivilege ",
      "SeManageVolumePrivilege",
      "SeProfileSingleProcessPrivilege",
      "SeSystemProfilePrivilege",
      "SeUnsolicitedInputPrivilege",
      "SeUndockPrivilege",
      "SeAssignPrimaryTokenPrivilege",
      "SeRestorePrivilege",
      "SeShutdownPrivilege",
      "SeSyncAgentPrivilege",
      "SeTakeOwnershipPrivilege"
    required: true 
	
  AllocationUnitSize:
    description: Allocation disk unit size
    validateSet: "512"","1024","2048","4096","8192","16384","32765","65536"
    default: 4096
	
  action:
    description: add or remove permission
    validateSet "grant","revoke"
    required: false

author:
    - "A.Faure "
'''

EXAMPLES = '''
# Playbook example
---

'''

