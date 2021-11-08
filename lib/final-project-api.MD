URL: ws://besquare-demo.herokuapp.com

# Getting all posts request:
{
    "type": "get_posts",
    "data": {
        "lastId": string
        "limit": int
    }
}

Getting all posts response:
{
    "type":"all_posts",
    "data":{
        "posts": [
            {
                "_id": string,
                "title": string,
                "description": string,
                "image": string,
                "date": string,
                "author": string
            }
        ]
    },
    "errors":[]
}

# Creating a post request:

{
    "type": "create_post",
    "data": {
        "title": string, 
        "description": string,
        "image": string
    }
}

# New Post created response:

{
    "type":"new_post",
    "data":{
        "_id": string,
        "title": string,
        "description": string,
        "image": string,
        "date": string,
        "author": string
    },
    "errors":[]
}

# Deleting a post request:
{
    "type": "delete_post",
    "data": {
        "postId": string
    }
}

# Deleting a post response:
{
    "type":"delete_post",
    "data": {
        "response": "OK" 
    },
    "errors": []
}

# Signing in request:

{
    "type": "sign_in",
    "data": {
        "name": string
    }
}

# Signing in response:

{
    "type":"sign_in",
    "data":{
        "response":"OK"
    },
    "errors":[]
}


# General responses:

{
    "type": "ping",
    "data":{},
    "errors":[]
}

{
    "type":"error",
    "data": {},
    "errors": [string]
}