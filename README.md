# Pulitzer
Articles content duplication detection and keywords extraction API service.

## Why
In 2020 during the COVID lock-down, I participated in the developer's competition - DevChallange. One of the tasks was to create an API service for article duplication detection.

Now at one of my commercial project business requires a quick solution for keywords extraction and text duplication detection so I thought it might be a good idea to use this solution and open-source it.

That's it.

## How to use
```sh
docker-compose up
```
and use `http://localhost:4000`

## Basic logic
1. Article content must be unique in the bucket
2. If the content is unique it will save it into DB
3. If the content is not unique it will not save in into DB and returns an original article data

## API

### Authentication
**!!!**
The current version does not support authentication.
Please use IP allowed lists and private networks for this.
Maybe in version 2.0, we will add this. Currently, we don't need this

### Create a bucket
**Bucket** - it's a unique scope for your articles. Presentation of account/project/anything on your end.

**Endpoint** `POST /api/v1/buckets`

**Body**
```json
{
    "identifier": "my_bucket"
}
```

**Fields**
- **required** `identifier` - unique identifier for articles scope. Only lower a-z, - and _ are allowed

**Success response example**

Status `201`
```json
{
    "identifier": "my_bucket"
}
```

**Failure response example**

Status `422`
```json
{
    "errors": {
        "identifier": [
            "has already been taken"
        ]
    }
}
```

### Create an article
**Endpoint** `POST /api/v1/:bucket_identifier/articles`

**Body**
```json
{
    "content": "article content should be here",
    "metadata": {
       "key": "value"
    }
}
```

**Fields**
- **required** `content` - Any text without special
- optional `metadata` - Any key/value pairs that can help you to tag articles from your side (maybe your DB PK ID)

**Success response example**

Status `201`
```json
{
    "action": "created",
    "article": {
        "content": "article content should be here",
        "id": 1,
        "keywords": [
            "article"
        ],
        "metadata": {
            "key": "value"
        },
        "words_count": 5
    }
}
```

**Failure response example**

Status: `422`
```json
{
    "action": "duplicate",
    "original": {
        "content": "article content should be here",
        "id": 1,
        "keywords": [
            "article"
        ],
        "metadata": {
            "key": "value"
        },
        "words_count": 5
    }
}
```
### Update an article
**Endpoint** `PUT /api/v1/:bucket_identifier/articles/:article_id`

TODO: implement

### List articles
**Endpoint** `GET /api/v1/:bucket_identifier/articles`

TODO: implement

### Search article
**Endpoint** `GET /api/v1/:bucket_identifier/articles`

TODO: implement

### Failure response codes
- `422` not valid input
- `400` missing required fields

## Inspector mode
Run service with environment variable `PULITZER_ENABLE_INSPECTOR=1`

## Distributed mode
Service can be run in the distributed mode for multiple nodes.

## Limitations
- Only English language
- No AI. We don't need it right now.
- Just a simple step by step algorithm
- Some endpoints are missing but it just because we don't need them now. Please create an issue if you need this and we can figure out what we can do
