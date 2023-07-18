--�⵵�� ����� ��ȸ

select count(*)||'��' as "2001�� �����" from employees where to_char(hire_date,'yyyy')=2001;
select count(*)||'��' as "2002�� �����" from employees where to_char(hire_date,'yyyy')=2002;
select count(*)||'��' as "2003�� �����" from employees where to_char(hire_date,'yyyy')=2003;

select to_char(hire_date,'yyyy')||'��' as "�Ի�⵵",count(to_char(hire_date,'yyyy'))||'��' as "�ο���"
from employees
group by to_char(hire_date,'yyyy')
order by "�Ի�⵵";

--������� ���� ���� 3�������� �μ��� ���ؼ�
--�⵵��/���� ä���ο��� �ľ�

-- ������� ���� ����3�������� �μ� ��ȸ
-- ����, �μ��ڵ�, �����

select *
from (select dense_rank() over(order by count(*) desc) rank, department_id,count(*)
from employees
group by department_id) e
where rank <=3
;

-- �޿��� ���� ����� ���� ����
--1�� ȫ�浿 2000
--2�� ȫ�浿 1500
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


-- �� ���� �μ� (30,50,80,100)�� ���ؼ��� ���� ä���ο��� ��ȸ
-- �μ���, �Ի��


select department_name, to_char(hire_date,'mm') unit
from employees e inner join
       (select rank,department_id,'('||'TOP'||rank||') '||department_name department_name
        from (select dense_rank() over(order by count(*) desc) rank, department_id,count(*) count
                from employees
                group by department_id) e left outer join departments d using(department_id)
 where rank <=3) r using (department_id);
        
        
-- ���� �������� --> ���ε����������� ���� : pivot
-- ���� �������� --> ���ε����������� ���� : unpivot

-- pivot / unpivot �Լ�
--select �÷�
--from (���̺�,�ζ��κ伭������ �� ���� �����͸� ��ȸ�ϴ� select )
--pivot (�����Լ�(ǥ����) for �ǹ�����÷� in(������ �ø� ��));

-- ���� �̷���� ��������
select 5 "1��",10"2��",20 "3��",25 "4��",5 "5��",15 "6��"
from dual;

--���� �̷���� ���������� ������ ��ȯ

select *
from( select 5 "01��",10"02��",20 "03��",25 "04��",5 "05��",15 "06��"
      from dual)
unpivot( cnt for mm in ("01��","02��","03��","04��","05��","06��"));


-- ������ �̷���� ���������� ���� ��ȯ
select *
from (select *
        from( select 5 "01��",10"02��",20 "03��",25 "04��",5 "05��",15 "06��"
              from dual)
        unpivot( cnt for mm in ("01��","02��","03��","04��","05��","06��")))
pivot ( sum(cnt) for mm in('01��','02��','03��','04��','05��','06��') );


-- �Ի���� �����

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
pivot(count(*) for unit in ('01' "01��",'02' "02��",'03' "03��",'04' "04��",'05' "05��",'06' "06��"))
order by department_name;
