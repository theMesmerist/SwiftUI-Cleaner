/*
 *  IPAddress.h
 *  SystemUtilities
 *
 *  Created by Tom Markel on 5/2/12.
 *  Copyright (c) 2012 MarkelSoft, Inc. All rights reserved.
 *
 */

#define MAXADDRS	32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void initAddresses();
void freeAddresses();
void getIPAddresses();
void getHWAddresses();