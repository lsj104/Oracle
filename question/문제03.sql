--sum()
--1. 유럽과 아프리카에 속한 나라의 인구 수 합? tblCountry > 14,198
select * from TBLCOUNTRY;
select sum(POPULATION) as 인구수 from TBLCOUNTRY where CONTINENT in ('EU', 'AF');

--2. 매니저(108)이 관리하고 있는 직원들의 급여 총합? hr.employees > 39,600
select * from EMPLOYEES;
select sum(SALARY) as 급여총합 from EMPLOYEES where MANAGER_ID = 108;

--3. 직업(ST_CLERK, SH_CLERK)을 가지는 직원들의 급여 합? hr.employees > 120,000
select sum(SALARY) as 급여총합 from EMPLOYEES where job_id in ('ST_CLERK', 'SH_CLERK');

--4. 서울에 있는 직원들의 급여 합(급여 + 수당)? tblInsa > 33,812,400
select * from TBLINSA;
select sum(BASICPAY) + sum(SUDANG) as 급여합 from TBLINSA where CITY = '서울';

--5. 장급(부장+과장)들의 급여 합? tblInsa > 36,289,000
select sum(BASICPAY) from TBLINSA where JIKWI in ('부장', '과장');


--avg()
--1. 아시아에 속한 국가의 평균 인구수? tblCountry > 39,165
select * from TBLCOUNTRY;
select avg(POPULATION) from TBLCOUNTRY where CONTINENT = 'AS';

--2. 이름(first_name)에 'AN'이 포함된 직원들의 평균 급여?(대소문자 구분없이) hr.employees > 6,270.4
select avg(SALARY) from EMPLOYEES where FIRST_NAME like '%an%' or FIRST_NAME like '%An%' or FIRST_NAME like '%aN%' or FIRST_NAME like '%AN%';

--3. 장급(부장+과장)의 평균 급여? tblInsa > 2,419,266.66
select avg(BASICPAY) from TBLINSA where JIKWI in ('부장', '과장');

--4. 사원급(대리+사원)의 평균 급여? tblInsa > 1,268,946.66
select avg(BASICPAY) from TBLINSA where JIKWI in ('대리', '사원');

--5. 장급(부장,과장)의 평균 급여와 사원급(대리,사원)의 평균 급여의 차액? tblInsa > 1,150,320

select avg(
    case when JIKWI in ('부장', '과장') then BASICPAY
    end
           )
-
       avg(
    case when JIKWI in ('대리', '사원') then BASICPAY
    end
           ) as 급여차액
from TBLINSA;



--max(),min()


--2. 급여(급여+수당)가 가장 적은 직원은 총 얼마를 받고 있는가? tblInsa > 988,000

select min(BASICPAY+SUDANG) from TBLINSA;



-- 추가
--1. traffic_accident. 각 교통 수단 별(지하철, 철도, 항공기, 선박, 자동차) 발생한 총 교통 사고 발생 수, 총 사망자 수, 사건 당 평균 사망자 수를 가져오시오.
select * from TRAFFIC_ACCIDENT;
select
    TRANS_TYPE as 교통수단,
    sum(TOTAL_ACCT_NUM) as 교통사고발생수,
    sum(DEATH_PERSON_NUM) as 총사망자수,
     round(sum(death_person_num) / sum(total_acct_num), 3) as "사건 당 평균 사망자수"
from TRAFFIC_ACCIDENT
group by TRANS_TYPE;

--2. tblZoo. 종류(family)별 평균 다리의 갯수를 가져오시오.
select * from TBLZOO;
select FAMILY as 종류,
       round(avg(LEG), 1) as 다리갯수
from TBLZOO
group by FAMILY;

--3. tblZoo. 체온이 변온인 종류 중 아가미 호흡과 폐 호흡을 하는 종들의 갯수를 가져오시오.
select
    count(
        case
            when BREATH = 'gill' then 1
        end
        ) as 아가미,
    count(
        case
            when BREATH = 'lung' then 1
        end
        ) as 폐
from TBLZOO
where THERMO = 'variable';

--4. tblZoo. 사이즈와 종류별로 그룹을 나누고 각 그룹의 갯수를 가져오시오.
select * from TBLZOO;
select SIZEOF as 사이즈,
       FAMILY as 종류,
       count(*)
from TBLZOO
group by SIZEOF, FAMILY
order by SIZEOF, FAMILY;

--5. tblAddressBook. 관리자의 실수로 몇몇 사람들의 이메일 주소가 중복되었다. 중복된 이메일 주소만 가져오시오.
select * from TBLADDRESSBOOK;
select
    EMAIL
from TBLADDRESSBOOK
group by EMAIL
having count(*) > 1
order by count(*) desc;

--6. tblAddressBook. 성씨별 인원수가 100명 이상 되는 성씨들을 가져오시오.
select
   substr(name, 1, 1),
   count(*)
from TBLADDRESSBOOK
group by substr(name, 1, 1)
having count(*) > 100;

--7. tblAddressBook. 이메일이 스네이크 명명법으로 만들어진 사람들 중에서 여자이며, 20대이며, 키가 150~160cm 사이며, 고향이 서울 또는 인천인 사람들만 가져오시오. 또는 인천인 사람들만 가져오시오.
select * from TBLADDRESSBOOK;
select
    *
from TBLADDRESSBOOK
where instr(email, '_') > 0
and GENDER = 'f'
and AGE between 20 and 29
and HEIGHT between 150 and 160
and hometown in ('서울', '인천');

--8. tblAddressBook. '건물주'와 '건물주자제분'들의 거주지가 서울과 지방의 비율이 어떻게 되느냐?












-- 정렬


-- employees
-- 1. 전체 이름(first_name + last_name)이 가장 긴 -> 짧은 사람 순으로 정렬해서 가져오기
--    > 컬럼 리스트 > fullname(first_name + last_name), length(fullname)

-- 2. 전체 이름(first_name + last_name)이 가장 긴 사람은 몇글자? 가장 짧은 사람은 몇글자? 평균 몇글자?
--    > 컬럼 리스트 > 숫자 3개 컬럼

-- 3. last_name이 4자인 사람들의 first_name을 가져오기
--    > 컬럼 리스트 > first_name, last_name
--    > 정렬(first_name, 오름차순)


-- decode

-- 4. tblInsa. 부장 몇명? 과장 몇명? 대리 몇명? 사원 몇명?


-- 5. tblInsa. 간부(부장, 과장) 몇명? 사원(대리, 사원) 몇명?


-- 6. tblInsa. 기획부, 영업부, 총무부, 개발부의 각각 평균 급여?

-- 7. tblInsa. 남자 직원 가장 나이가 많은 사람이 몇년도 태생? 여자 직원 가장 나이가 어린 사람이 몇년도 태생?