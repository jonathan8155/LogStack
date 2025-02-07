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

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the name of the account that reported information about successful logon. |
| SubjectUserName | String | 50 | The domain of the account that reported information about successful logon. |
| TargetDomainName | String | 50 | The domain of the account for which logon was performed. |
| TargetUserName | String | 50 | the name of the account for which logon was performed. |
| LogonType | Integer | 2 | the type of logon that happened. |
| TargetLogonID | String | 10 | hexadecimal value that can help you correlate this event with recent events that might contain the same Logon ID |
| ElevatedToken | String | 3 | UnicodeString]: a "Yes" or "No" flag. If "Yes", then the session this event represents is elevated and has administrator privileges. |

### 4625: An account failed to log on

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the name of the account that reported information about logon failure. |
| SubjectUserName | String | 50 | The domain of the account that reported information about logon failure. |
| TargetDomainName | String | 50 | the domain of the account that was specified in the logon attempt. |
| TargetUserName | String | 50 | the name of the account that was specified in the logon attempt. |
| LogonType | Integer | 2 | the type of logon that was performed.  |
| FailureReason | String | 50 | textual explanation of Status field value. |
| Status | String | 12 | the reason why logon failed. |

## 4720: A user account was created.

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | the domain or computer of the account that requested the "create user account" operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “create user account” operation. |
| TargetDomainName | String | 50 | the domain or computer of the account that was created. |
| TargetUserName | String | 50 | the name of the user account that was created. |

### 4722: A user account was enabled.

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4723: An attempt was made to change an account's password.

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |
| Keywords | String | 20 |

### 4724: An attempt was made to reset an account's password.

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |
| Keywords | String | 20 |

### 4725

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4726
| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4749

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4767

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4731

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4732: A member was added to a security-enabled local group

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: |:---: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | |
| SubjectUserName | String | 50 | |
| TargetDomainName | String | 50 | The domain of the group a user was added too. |
| TargetUserName | String | 50 | The name of the group a user was added too. |
| TargetDomainName | String | 50 | The domain of the group a user was added too. |
| MemberName | String | 100 | The account that was added to a group. |

### 4733: A member was removed from a security-enabled local group.

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: | :----: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 | The domain or computer of the account that requested the operation. |
| SubjectUserName | String | 50 | the name of the account that requested the “remove member from the group” operation. |
| TargetDomainName | String | 50 | The domain of the group a user was added too. |
| TargetUserName | String | 50 | the name of the group from which the member was removed |
| TargetDomainName | String | 50 | domain or computer name of the group from which the member was removed. |
| MemberName | String | 100 | distinguished name of account that was removed from the group. |

### 4734

| Field Name | Data Type | Character Limit | Notes |
| :---: | :----: | :----: | :----: |
| TimeCreated | String? | 50 | The time stamp that identifies when the event was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-timecreated-systempropertiestype-element |
| Computer | String | 50 | The name of the computer where the event originated. |
| EventRecordID | Integer | 10 | The record number assigned to the event when it was logged. <br> https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-eventrecordid-systempropertiestype-element |
| SubjectDomainName | String | 50 |
| SubjectUserName | String | 50 |
| TargetDomainName | String | 50 |
| TargetUserName | String | 50 |

### 4672: Special privileges assigned to new logon



### 4673

### 4674

### 1102

## Data Security

Information security focuses on balancing on three core aspects: 
- **confidentiality** This involves protecting the information from unauthorized access.
- **integrity** This involves protecting the information from unauthorized or unintentional change (modification or deletion).
- **availability.** This involves ensuring the data is available to authorized users whenever it is needed.

## Dependancies

## Development Tools
