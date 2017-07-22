# React Backend

## Installation
```
bundle install
be rake db:setup
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
Update | /users/7/ | PUT | as user | Updates the password for a user

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
Unknown user | 404 | {type: "NotFound"}
Not logged in | 403 | { type: "Unauthorized" }

- - -

#### Session
A session is used to log a user in and out. When logged in, a user can access routes specific to that user, or one of a friend.

When logging in, a cookie is created on the frontend, and that is automatically sent in subsequent routes.

#### Create

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Create | /sessions | POST | no | Logs in a user

Parameters:

Name | Type | Required | Example
-----|------|-----------|-------
user | hash | yes         | user: { name: ... }
user[:name] | string | yes | 'the commish'
user[:password] | string | yes | 'password1'

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 201 | { id: 7 }
Already have a session | 400 | { type: "AlreadyLoggedIn" }
Missing params | 400 | { type: "ParameterMissing" }
Username or password invalid | 403 | { type: "Unauthorized" }
- - -

### Friend
Friends are a way to associate a friend with another.
Adding a friend gives that user permission to view extra data, such as your friend list.

#### Index
Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Index | /users/7/friends/ | GET | as user or friend of user | A list of the users's friends

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | [{ id: 8, name: "Anil"} , { id: 21, name: "luciana_díaz"} ...]
Unknown user | 404 | {type: "NotFound"}
Not logged in as user 7 or user 7's friends | 403 | { type: "Unauthorized" }

#### Create

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Create | /users/7/friends | POST | as user | Adds a new friend to user 7

Parameters:

Note: Either the name or the id is required. If both are present, then the id is used.

Name | Type | Required | Example
-----|------|-----------|-------
friend | hash | yes | friend: { name: ... }
friend[:name] | string | no | 'luciana_díaz'
friend[:id] | integer | no | 21

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 201 | [{ id: 8, name: "Anil"} , { id: 21, name: "luciana_díaz"} ...]
Missing params | 400 | { type: "ParameterMissing" }
Params invalid | 400 | { type: "InvalidData" }
Friending yourself | 400 | { type: "InvalidData" }
User already exists | 400 | { type: "UserExists" }
Unknown user | 404 | {type: "NotFound"}
Not logged in as user 7 | 403 | { type: "Unauthorized" }

#### Delete
Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Destroy | /users/7/friends/21 | DELETE | as user | Removes friend 21 from user 7's friend list

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 201 | [{ id: 8, name: "Anil"} , { id: 21, name: "luciana_díaz"} ...]
Missing params | 400 | { type: "ParameterMissing" }
Params invalid | 400 | { type: "InvalidData" }
Unknown user | 404 | {type: "NotFound"}
Not logged in as user 7 | 403 | { type: "Unauthorized" }

- - -

### Book
Books can be used in two ways. There is the /books/ route that is used to interact with all books in the library. Only admins can create or remove books from the service. Additionally, you can associate a book with a particular user with /users/7/books/. Per-user associations are _not_ mutually exclusive (meaning that multiple users can have the same book.

#### Index
Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Index | /books/ | GET | no | A list of all books

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | [{ id: 6, title: "The Mermaids Singing", author: "Miss Lilyan McCullough", publisher: "SAGE Publications", genre: "Reference book"} ...]

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Index | users/7/books/ | GET | as user or friend of user 7 | A list of all books associated with the user

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | [{ id: 6, title: "The Mermaids Singing", author: "Miss Lilyan McCullough", publisher: "SAGE Publications", genre: "Reference book"} ...]
Unknown user | 404 | {type: "NotFound"}
Not logged in as the user or a friend | 403 | {type: "Unauthorized"}

#### Show
Returns the information about a specific book

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Index | /books/6 | GET | no | The details of book 6

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | { id: 6, title: "The Mermaids Singing", author: "Miss Lilyan McCullough", publisher: "SAGE Publications", genre: "Reference book"}
Unknown book | 404 | {type: "NotFound"}

#### Create
TBD

#### Update
Adds a book to a user's collection.

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Update | users/7/books/6 | PUT | as user | Adds book 6 to user 7's books

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | [{ id: 6, title: "The Mermaids Singing", author: "Miss Lilyan McCullough", publisher: "SAGE Publications", genre: "Reference book"}, ...]
Unknown book or user | 404 | {type: "NotFound"}
Not logged in as the user | 403 | {type: "Unauthorized"}

#### Destroy
Removes a book from the database

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Delete | /books/6 | DELETE | admin | Removes book 6 from the database

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | {status: "destroyed"}
Unknown book or user | 404 | {type: "NotFound"}
Not logged in as an admin | 403 | {type: "Unauthorized"}

Removes a book from a user's collection

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Delete | users/7/books/6 | DELETE | as user | Removes book 6 from user 7's books

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | {status: "destroyed"}
Unknown book or user | 404 | {type: "NotFound"}
Not logged in as user 7 | 403 | {type: "Unauthorized"}

#### Search
Finds all books in the database by genre

Name | URL | Method | Auth | Description
-----|-----|--------|------|------------
Search | /books/search/Reference%20book | GET | no | Finds all books that are in the Reference book genre

Parameters: None

Potential responses:

Type   | Status | Example
-------|--------|--------
Success | 200 | [{ id: 6, title: "The Mermaids Singing", author: "Miss Lilyan McCullough", publisher: "SAGE Publications", genre: "Reference book"}, ...]
No results found | 404 | {type: "NotFound"}
