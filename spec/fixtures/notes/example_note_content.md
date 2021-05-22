# HEADING 1

## HEADING 2

### HEADING 3

@startuml

Alice -> Bobby: synchronous call
Alice ->> Bobby: asynchronous call

@enduml

@startuml

Bobby -> Alice: synchronous call
Bobby ->> Alice: asynchronous call

@enduml

- BULLET 1
- BULLET 2
- BULLET 3

- [ ] CHECKBOX 1
  - [ ] NESTED CHECKBOX 1
- [x] CHECKBOX 2

```ruby
  module Commentable   
    def self.included(base)     
      base.class_eval do       
        has_many :comments, as: :commentable     
      end   
    end
  end
```

[LINK 1](https://example.com)

| KEY      | id       |
|----------|----------|
| AAAAAAAA | 24021117 |
| BBBBBBBB | 24166313 |
| CCCCCCCC | 24406745 |

![image1.png](:storage/example_note/4a8047fa.png)

