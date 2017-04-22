# React Backend

## Installation
```
bundle install
be db:setup
be rails s
```

## Overview
* Users have a username and password, and can be an admin
* You can log in as a user and use that cookie to access routes that require authorization.
* There are a variety of books with titles, authors etc. Anyone can view a list but only admins can add or remove books
* In addition to the entire collection of books, a user can also add and remove books to their account
* A user also can have friends. If Jordan friends Anil, then Anil has the ability to view some of Jordan's pages (such as the books in Jordan's account).
* Friends are uni-directional. Meaning that in the above example, Jordan can't see Anil's books until Anil friends Jordan.

## Routes

### User

#### Create

Notes: The name is always lower-cased on the backend side.

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Create | /users/ | POST | no | Creates a new user

Parameters:

Name | Type | Required | Example
-----|------|-----------|-------
user | hash | yes         | user: { name: ... }
user[:name] | string | yes | 'the commish'
user[:password] | string | yes | 'password1'
user[:is_admin?] | boolean | no | false

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | { id: 7, name: "jordan" }
Missing params | 400 | { type: "ParameterMissing" }
Params invalid | 400 | { type: "InvalidData" }
User already exists | 400 | { type: "UserExists" }

#### Update

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Update | /users/1/ | PUT | as user | Updates the password for a user

Parameters:

Name | Type | Required | Example
-----|------|-----------|-------
user | hash | yes         | user: { password: ... }
user[:password] | string | yes | 'password1'

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | { id: 7, name: "jordan" }
Missing params | 400 | { type: "ParameterMissing" }
Params invalid | 400 | { type: "InvalidData" }
Not logged in | 403 | { type: "Unauthorized" }
