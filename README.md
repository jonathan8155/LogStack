# LogStack

Bare bones windows event log analyzer tool

## Concept

Many security frameworks require reviewing system logs for various indicators of compromise, or unusual activity.
For large scale systems (server-client archetecture, etc.) there are already tools (SIEMs) built for handling this.
Splunk and ArcSight are two examples of many.
While this SIEMs are quite effective, robust, and have quite a wide array of capabilities these tools are frequently 
large, resource itensive (in physical, logical, and business sense.) and expensive.

For smaller environments, such as single standalone computers these solutions are not a good fit.  As the organization
frequently does not have the money, manhours, or skill to utilize larger and more complicated SIEMs.  In these situations
the organization is frequently forced to rely on built-in system log viewing tools and or debugging tools such as the 
Windows Event Viewer or Auditd often found in Linux systems.  These tools vary widely in terms of functionality and how
intuitive they are to use.

## Scope

The idea behind LogStack is to address these issues for single computer environments runing a Windows operting system such 
as Windows 10, Windows 11, Windows Server 2019, etc.

## Data Flow

**DATA INPUT PHASE**

The Windows OS stored event logs in the system log files.  The running logs can be exported to evtx files.  Those evtx files
can be read and parsed using tools such as powershell.

**DATA STORAGE PHASE**

The parsed data is stored as structured data in a sql database.

**DATA PRESENTATION PHASE**

The database is queried using prebuild sql queries the end user can choose from.  The data is then presented to the user
through a GUI.

## Data Structure

Each type of event (Each eventid) has its own table within the database.  The draft structure is as follows.

### 4624: An account was successfully logged on.

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the name of the account that reported information about successful logon. |
| SubjectUserName | String | 50 | The domain of the account that reported information about successful logon. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | The domain of the account for which logon was performed. |
| TargetUserName | String | 50 | the name of the account for which logon was performed. |
| TargetLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| LogonType | Integer | 2 | the type of logon that happened. |
| ElevatedToken | String | 3 | a "Yes" or "No" flag. If "Yes", then the session this event represents is elevated and has administrator privileges. |

### 4625: An account failed to log on

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the name of the account that reported information about logon failure. |
| SubjectUserName | String | 50 | The domain of the account that reported information about logon failure. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain of the account that was specified in the logon attempt. |
| TargetUserName | String | 50 | the name of the account that was specified in the logon attempt. |
| LogonType | Integer | 2 | the type of logon that was performed.  |
| FailureReason | String | 50 | textual explanation of Status field value. |
| Status | String | 12 | the reason why logon failed. |

## 4720: A user account was created.

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the "create user account" operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “create user account” operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account that was created. |
| TargetUserName | String | 50 | the name of the user account that was created. |

### 4722: A user account was enabled.

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of hte account that requested the "enable account" operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “enable account” operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account that was enabled.|
| TargetUserName | String | 50 | the name of the account that was enabled. |

### 4723: An attempt was made to change an account's password.

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that made an attempt to change the Target’s Account password.|
| SubjectUserName | String | 50 | the name of the account that made an attempt to change the Target’s Account password. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account for which the password change was requested. |
| TargetUserName | String | 50 | the name of the account for which the password change was requested. |
| Keywords | String | 20 | The status of the attempted password change.  <br> 0x8010000000000000 = Attempt failed <br> 0x8020000000000000 = attempt succeeded |

### 4724: An attempt was made to reset an account's password.

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that made an attempt to reset the Target’s Account password.|
| SubjectUserName | String | 50 | the name of the account that made an attempt to reset the Target’s Account password. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account for which the password reset was requested. |
| TargetUserName | String | 50 | the name of the account for which the password reset was requested. |
| Keywords | String | 20 | The status of the attempted password reset.  <br> 0x8010000000000000 = Attempt failed <br> 0x8020000000000000 = attempt succeeded |

### 4725: A user account was disabled

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the “disable account” operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “disable account” operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account that was disabled. |
| TargetUserName | String | 50 | the name of the account that was disabled. |

### 4726: A user account was deleted.
| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the “delete account” operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “delete account” operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account that was deleted. |
| TargetUserName | String | 50 | the name of the account that was deleted. |

### 4749: A security-disabled global group was created.

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the "create group” operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “create group” operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the group that was created. |
| TargetUserName | String | 50 | the name of the group that was created. |

### 4767:  A user account was unlocked

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that performed the unlock operation. |
| SubjectUserName | String | 50 | the name of the account that performed the unlock operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the account that was unlocked. |
| TargetUserName | String | 50 | the name of the account that was unlocked. |

### 4731: A security-enabled local group was created

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4731

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the "create group" operation. |
| SubjectUserName | String | 50 | the name of the account that requested the "create group" operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the group that was created. |
| TargetUserName | String | 50 | the name of the group that was created. |

### 4732: A member was added to a security-enabled local group

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4732

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: |:---: | :---: | 
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the "add member to group" operation. |
| SubjectUserName | String | 50 | the name of the account that requested the "add member to group" operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | The domain of the group a user was added too. |
| TargetUserName | String | 50 | The name of the group a user was added too. |
| MemberName | String | 100 | distinguished name of account that was added to the group. |

### 4733: A member was removed from a security-enabled local group.

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4733

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: | :----: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | The domain or computer of the account that requested the operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “remove member from the group” operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | The domain of the group a user was added too. |
| TargetUserName | String | 50 | the name of the group from which the member was removed |
| MemberName | String | 100 | distinguished name of account that was removed from the group. |

### 4734: A security-enabled local group was deleted

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4734

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: | :----: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the "delete group" operation. |
| SubjectUserName | String | 50 | the name of the account that requested the "delete group" operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| TargetDomainName | String | 50 | the domain or computer of the deleted group. |
| TargetUserName | String | 50 | the name of the group that was deleted. |

### 4672: Special privileges assigned to new logon

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4672

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: | :----: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that was given special privileges. |
| SubjectUserName | String | 50 | the name of the account that was given special privileges. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| Privileges | String | 200 | the list of sensitive privileges assigned to the new logon. |

### 4673: A privileged service was called

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4673

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: | :----: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the privileged operation. |
| SubjectUserName | String | 50 | the name of the account that requested the privileged operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| ObjectServer | String | 50 | contains the name of the Windows subsystem calling the routine. |
| Service | String | 50 | supplies a name of the privileged subsystem called. |
| PrivilegeList | String | 200 | the list of user privileges which were requested.
| Keywords | String | 20 | The status of the attempted privileged service call.  <br> 0x8010000000000000 = Attempt failed <br> 0x8020000000000000 = attempt succeeded |

### 4674: An operation was attempted on a privileged object

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4674

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: | :----: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the privileged operation. |
| SubjectUserName | String | 50 | the name of the account that requested the privileged operation. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| ObjectServer | String | 50 | contains the name of the Windows subsystem calling the routine. |
| Service | String | 50 | supplies a name of the privileged subsystem called. |
| Privileges | string | 200 | the list of user privileges which were requested. |

### 1102: The audit log was cleared

https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-1102

| Field Name | Data Type | Character Limit | Description | Notes |
| :---: | :----: | :----: | :----: | :---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that cleared the audit log. |
| SubjectUserName | String | 50 | the name of the account that cleared the audit log. |
| SubjectLogonId | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |

## Data Security

Information security focuses on balancing on three core aspects: 
- **confidentiality** This involves protecting the information from unauthorized access.
- **integrity** This involves protecting the information from unauthorized or unintentional change (modification or deletion).
- **availability.** This involves ensuring the data is available to authorized users whenever it is needed.

## Dependancies

## Development Tools
