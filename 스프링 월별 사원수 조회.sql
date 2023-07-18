--년도별 사원수 조회

select count(*)||'명' as "2001년 사원수" from employees where to_char(hire_date,'yyyy')=2001;
select count(*)||'명' as "2002년 사원수" from employees where to_char(hire_date,'yyyy')=2002;
select count(*)||'명' as "2003년 사원수" from employees where to_char(hire_date,'yyyy')=2003;

select to_char(hire_date,'yyyy')||'년' as "입사년도",count(to_char(hire_date,'yyyy'))||'명' as "인원수"
from employees
group by to_char(hire_date,'yyyy')
order by "입사년도";

--사원수가 많은 상위 3위까지의 부서에 대해서
--년도별/월별 채용인원수 파악

-- 사원수가 많은 상위3위까지의 부서 조회
-- 순위, 부서코드, 사원수

select *
from (select dense_rank() over(order by count(*) desc) rank, department_id,count(*)
from employees
group by department_id) e
where rank <=3
;

-- 급여가 많은 사원에 대한 순위
--1위 홍길동 2000
--2위 홍길동 1500
select rownum,e.*
from (select  employee_id,salary
from employees
where salary is not null
order by salary desc) e;



select rank,department_id,'('||'TOP'||rank||') '||department_name
from (select dense_rank() over(order by count(*) desc) rank, department_id,count(*)
from employees
group by department_id) e left outer join departments d using(department_id)
where rank <=3;


-- 위 상위 부서 (30,50,80,100)에 대해서만 월별 채용인원수 조회
-- 부서명, 입사월


select department_name, to_char(hire_date,'mm') unit
from employees e inner join
       (select rank,department_id,'('||'TOP'||rank||') '||department_name department_name
        from (select dense_rank() over(order by count(*) desc) rank, department_id,count(*) count
                from employees
                group by department_id) e left outer join departments d using(department_id)
 where rank <=3) r using (department_id);
        
        
-- 세로 데이터행 --> 가로데이터행으로 변경 : pivot
-- 가로 데이터행 --> 세로데이터행으로 변경 : unpivot

-- pivot / unpivot 함수
--select 컬럼
--from (테이블,인라인뷰서브쿼리 로 부터 데이터를 조회하는 select )
--pivot (집계함수(표현식) for 피벗대상컬럼 in(행으로 올릴 열));

-- 열로 이루어진 데이터행
select 5 "1월",10"2월",20 "3월",25 "4월",5 "5월",15 "6월"
from dual;

--열로 이루어진 데이터행을 행으로 변환

select *
from( select 5 "01월",10"02월",20 "03월",25 "04월",5 "05월",15 "06월"
      from dual)
unpivot( cnt for mm in ("01월","02월","03월","04월","05월","06월"));


-- 행으로 이루어진 데이터행을 열로 변환
select *
from (select *
        from( select 5 "01월",10"02월",20 "03월",25 "04월",5 "05월",15 "06월"
              from dual)
        unpivot( cnt for mm in ("01월","02월","03월","04월","05월","06월")))
pivot ( sum(cnt) for mm in('01월','02월','03월','04월','05월','06월') );


-- 입사월별 사원수

select *
from ( select to_char(hire_date,'mm')mm from employees)
pivot ( count(*) for mm in('01','02','03','04','05','06'));


select *
from (
            select department_name, to_char(hire_date,'mm') unit
            from employees e inner join
                   (select rank,department_id,'('||'TOP'||rank||') '||department_name department_name
                    from (select dense_rank() over(order by count(*) desc) rank, department_id,count(*) count
                            from employees
                            group by department_id) e left outer join departments d using(department_id)
             where rank <=3) r using (department_id)
)
pivot(count(*) for unit in ('01' "01월",'02' "02월",'03' "03월",'04' "04월",'05' "05월",'06' "06월"))
order by department_name;
