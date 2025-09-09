-- 2. dept 전체조회를 하려고 합니다.querydsl 로 작성하세요



POST /dept/_search
{
  "query": {
    "match_all": {}
  }
}

