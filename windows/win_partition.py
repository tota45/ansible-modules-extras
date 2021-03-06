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
module: win_partition
version_added: "1"
short_description: Manages local partition on windows host
description:
     - Manages local partition on windows host
options:
  DiskID:
    description: Disk ID to modify. Default system disk is 0.
    required: true
	
  driveletter:
    description: Drive letter to assign to the disk
    required: true
	
  partitionsize:
    description: Disk size. Must be a value in GB. "remainingsize" string is recognized also
    required: true
    default: 1
	
  typedisk:
    description: partition type
    required: true
    validateSet: "GPT","MBR"
	
  FileSystem:
    description: File system Type
    validateSet: "NTFS","ReFS","exFAT","FAT32","FAT"
    default "NTFS"
	
  AllocationUnitSize:
    description: Allocation disk unit size
    validateSet: "512","1024","2048","4096","8192","16384","32765","65536"
    default: 4096
	
  NewFileSystemLabel:
    description: Drive label
    required: true

author:
    - "A.Faure "
'''

EXAMPLES = '''
# Playbook example
---
- name: Create a new partition
  hosts: all
  tasks:
    - name: Create a new partition
      win_partition:
        diskid: 1
        driveletter: G
        partitionsize : 10
        typedisk: GPT
        fileSystem: NTFS
        allocationunitsize: 1024
        newfilesystemlabel: ansible

- name: Create a new partition
  hosts: all
  tasks:
    - name: Create a new partition
      win_partition:
        diskid: 0
        driveletter: C
        partitionsize : remainningsize
        typedisk: MBR
        fileSystem: NTFS
        newfilesystemlabel: SYSTEM
'''

