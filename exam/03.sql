
-- 3. 아래 문항을 코딩하세요 지시된 사항외에 나머지는 자유롭게 하세요

-- 3-1) 부서별 급여 합계 구합니다.(group by dno)  
POST /dpet/_search
{
  "size": 0,
  "aggs": {
    "tdno": {
      "terms": {
        "field": "dno"
      },
      "aggs": {
        "ssalary": {
          "sum": {
            "field": "salary"
          }
        }
      }
    },
    "tsum":{
      "sum_bucket": {
        "buckets_path": "tdno>ssalary"
      }
    }
  }
}

-- 3-2) QNA 오라클 테이블을 그대로 복제해서 ElasticSearch에 인덱스로 만드는 로그시태쉬 conf 파일을 작성하세요
input {
    jdbc {
        # 오라클 연결
        jdbc_driver_library => "C:/Work/10_Elastic_Search/chap12/ojdbc11.jar" # 라이브러리 경로
        jdbc_driver_class => "Java::oracle.jdbc.driver.OracleDriver"          # 오라클 클래스
        jdbc_connection_string => "jdbc:oracle:thin:@localhost:1521:xe"       # 오라클 접속정보
        jdbc_user => "scott"                                                  # 오라클 계정
        jdbc_password => "!Ds1234567890"                                      # 오라클 암호

        # SQL 작성: 데이터 수집
        statement => "
        select qno, questioner, question, 
            answer, answerer, insert_time, update_time 
        from tb_qna
        "
        # 스케줄 걸기: 1분마다 실행: 크론잡 표현식(변경분만 실행: 최적화됨)
        # * : 매시, 매분, 매일 등
        # 크론잡 표현식 사용법: "분 시 일 월 요일"
        schedule => "* * * * *"
    }
}
filter {
}

output {
    # 엘라스틱서치 연결
    elasticsearch {
        hosts => ["http://localhost:9200"] 
        index => "qna2"                 
        document_id => "%{qno}"            
    }
    stdout { codec => json_lines }      
}
-- 3-3) FAQ 오라클 테이블을 그대로 복제해서 ElaticSearch에 인덱스로 만드는 로그스태쉬 conf 파일을 작성하세요
input {
    jdbc {
        # 오라클 연결
        jdbc_driver_library => "C:/Work/10_Elastic_Search/chap12/ojdbc11.jar" # 라이브러리 경로
        jdbc_driver_class => "Java::oracle.jdbc.driver.OracleDriver"          # 오라클 클래스
        jdbc_connection_string => "jdbc:oracle:thin:@localhost:1521:xe"       # 오라클 접속정보
        jdbc_user => "scott"                                                  # 오라클 계정
        jdbc_password => "!Ds1234567890"                                      # 오라클 암호

        # SQL 작성: 데이터 수집
        statement => "
        select fno, title, content, insert_time, update_time 
        from tb_fna
        "
        # 스케줄 걸기: 1분마다 실행: 크론잡 표현식(변경분만 실행: 최적화됨)
        # * : 매시, 매분, 매일 등
        # 크론잡 표현식 사용법: "분 시 일 월 요일"
        schedule => "* * * * *"
    }
}
filter {
}

output {
    # 엘라스틱서치 연결
    elasticsearch {
        hosts => ["http://localhost:9200"] 
        index => "fnq2"                 
        document_id => "%{fno}"            
    }
    stdout { codec => json_lines }      
}