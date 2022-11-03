--sum()
--1. 유럽과 아프리카에 속한 나라의 인구 수 합? tblCountry > 14,198
select sum(population) as 인구수 from tblCountry where continent in ('EU', 'AF');


--2. 매니저(108)이 관리하고 있는 직원들의 급여 총합? hr.employees > 39,600
select sum(salary) as 급여총합 from employees where manager_id = 108;


--3. 직업(ST_CLERK, SH_CLERK)을 가지는 직원들의 급여 합? hr.employees > 120,000
select sum(salary) from employees where job_id in ('ST_CLERK', 'SH_CLERK');


--4. 서울에 있는 직원들의 급여 합(급여 + 수당)? tblInsa > 33,812,400
select sum(basicpay + sudang) from tblInsa where city = '서울';


--5. 장급(부장+과장)들의 급여 합? tblInsa > 36,289,000
select sum(basicpay) from tblInsa where jikwi in ('과장', '부장');



--avg()
--1. 아시아에 속한 국가의 평균 인구수? tblCountry > 39,165
select avg(population) from tblCountry where continent = 'AS';


--2. 이름(first_name)에 'AN'이 포함된 직원들의 평균 급여?(대소문자 구분없이) hr.employees > 6,270.4
select avg(salary) from employees where first_name like '%AN%' or first_name like '%An%' or first_name like '%aN%' or first_name like '%an%';


--3. 장급(부장+과장)의 평균 급여? tblInsa > 2,419,266.66
select avg(basicpay) from tblInsa where jikwi in ('과장', '부장');


--4. 사원급(대리+사원)의 평균 급여? tblInsa > 1,268,946.66
select avg(basicpay) from tblInsa where jikwi in ('사원', '대리');


--5. 장급(부장,과장)의 평균 급여와 사원급(대리,사원)의 평균 급여의 차액? tblInsa > 1,150,320
select
    avg(
        case
            when jikwi in ('과장', '부장') then basicpay
        end
    )
    -
    avg(
        case
            when jikwi in ('사원', '대리') then basicpay
        end
    )
from tblInsa;



--max(),min()


--2. 급여(급여+수당)가 가장 적은 직원은 총 얼마를 받고 있는가? tblInsa > 988,000
select min(basicpay + sudang) from tblInsa;

-- employees
-- 1. 전체 이름(first_name + last_name)이 가장 긴 -> 짧은 사람 순으로 정렬해서 가져오기
--    > 컬럼 리스트 > fullname(first_name + last_name), length(fullname)
select
    first_name || ' ' || last_name as fullname, length(first_name || ' ' || last_name) as namelength
from employees
    order by namelength asc;

-- 2. 전체 이름(first_name + last_name)이 가장 긴 사람은 몇글자? 가장 짧은 사람은 몇글자? 평균 몇글자?
--    > 컬럼 리스트 > 숫자 3개 컬럼
select
    max(length(first_name || last_name)) as maxlength, min(length(first_name || last_name)) as minlength,
    round(avg(length(first_name || last_name))) as avglength
from employees;

-- 3. last_name이 4자인 사람들의 first_name을 가져오기
--    > 컬럼 리스트 > first_name, last_name
--    > 정렬(first_name, 오름차순)
select
    first_name, last_name
from employees
    where length(last_name) = 4 order by length(first_name) asc;

-- tblInsa. 부장 몇명? 과장 몇명? 대리 몇명? 사원 몇명?
select
    count(decode(jikwi, '부장', 1)),
    count(decode(jikwi, '과장', 1)),
    count(decode(jikwi, '대리', 1)),
    count(decode(jikwi, '사원', 1))
from tblInsa;



-- tblInsa. 간부(부장, 과장) 몇명? 사원(대리, 사원) 몇명?

select
    count(decode(jikwi, '부장', 1)) + count(decode(jikwi, '과장', 1)) as 간부,
    count(decode(jikwi, '대리', 1)) + count(decode(jikwi, '사원', 1)) as 사원
from tblInsa;

select
    count(decode(jikwi, '부장', 1, '과장', 2)) as 간부,
    count(decode(jikwi, '대리', 3, '사원', 4)) as 사원
from tblInsa;


-- tblInsa. 기획부, 영업부, 총무부, 개발부의 각각 평균 급여?
select
    count(decode(buseo, '기획부', 1)) as 기획부,
    count(decode(buseo, '영업부', 1)) as 영업부,
    count(decode(buseo, '총무부', 1)) as 총무부,
    count(decode(buseo, '개발부', 1)) as 개발부
from tblInsa;

select
    decode(buseo, '기획부', basicpay) as 기획부,
    decode(buseo, '영업부', basicpay) as 영업부,
    decode(buseo, '총무부', basicpay) as 총무부,
    decode(buseo, '개발부', basicpay) as 개발부
from tblInsa;

select
    round(avg(decode(buseo, '기획부', basicpay))) as 기획부,
    round(avg(decode(buseo, '영업부', basicpay))) as 영업부,
    round(avg(decode(buseo, '총무부', basicpay))) as 총무부,
    round(avg(decode(buseo, '개발부', basicpay))) as 개발부
from tblInsa;

-- tblAddressBook. 학생 몇명? 건물주 몇명?
select
    count(decode(job, '학생', 1)) as 학생,
    count(decode(job, '건물주', 1)) as 건물주
from tblAddressBook;


-----------------------


-- tblInsa. 남자 직원 가장 나이가 많은 사람이 몇년도 태생? 여자 직원 가장 나이가 어린 사람이 몇년도 태생?
select
    '19' || min(decode(substr(ssn, 8, 1), '1', substr(ssn, 1, 2))),
    '19' || max(decode(substr(ssn, 8, 1), '2', substr(ssn, 1, 2)))
from tblInsa;




--1. traffic_accident. 각 교통 수단 별(지하철, 철도, 항공기, 선박, 자동차)
-- 발생한 총 교통 사고 발생 수, 총 사망자 수, 사건 당 평균 사망자 수를 가져오시오.
select * from traffic_accident;

select
    trans_type as "교통수단명",
    sum(total_acct_num) as "총 교통사고 발생 수",
    sum(death_person_num) as "총 사망자수",
    round(sum(death_person_num) / sum(total_acct_num), 3) as "사건 당 평균 사망자수"
from traffic_accident
    group by trans_type;


--2. tblZoo. 종류(family)별 평균 다리의 갯수를 가져오시오.
select
    family as "종",
    round(avg(leg), 1) as "평균 다리 갯수"
from tblZoo
    group by family;

--3. tblZoo. 체온이 '변온'인 종류 중 > 아가미 호흡과 폐 호흡을 하는 종들의 갯수를 가져오시오.
select
    count(case
        when breath = 'gill' then 1
    end) as "변온, 아가미 호흡",
    count(case
        when breath = 'lung' then 1
    end) as "변온, 폐 호흡"
from tblZoo
    where thermo = 'variable';



select
    breath,
    count(*)
from tblZoo
    where thermo = 'variable'
        group by breath;


select
    breath,
    count(*)
from tblZoo
    group by thermo, breath
        having thermo = 'variable'; --그룹 조건


--4. tblZoo. 사이즈와 종류별로 그룹을 나누고 각 그룹의 갯수를 가져오시오.
select
    sizeof,
    family,
    count(*)
from tblZoo
    group by sizeof, family
        order by sizeof, family;


--5. tblAddressBook. 관리자의 실수로 몇몇 사람들의 이메일 주소가 중복되었다. 중복된 이메일 주소만 가져오시오.
select count(*) from tblAddressBook; --2000
select count(*) - count(distinct email) from tblAddressBook; --245개 중복 > 이 이메일들이 궁금??

select
    email
    --count(*)
from tblAddressBook
    group by email
        having count(*) > 1
            order by count(*) desc;



--6. tblAddressBook. 성씨별 인원수가 100명 이상 되는 성씨들을 가져오시오.
select
    substr(name, 1, 1),
    count(*)
from tblAddressBook
    group by substr(name, 1, 1)
        having count(*) >= 100;



--7. tblAddressBook. 이메일이 스네이크 명명법으로 만들어진 사람들 중에서
-- 여자이며, 20대이며, 키가 150~160cm 사이며, 고향이 서울 또는 인천인 사람들만 가져오시오. 또는 인천인 사람들만 가져오시오.
select
    *
from tblAddressBook
    where instr(email, '_') > 0
        and gender = 'f'
        and age between 20 and 29
        and height between 150 and 160
        and hometown in ('서울', '인천');



--8. tblAddressBook. '건물주'와 '건물주자제분'들의 거주지가 서울과 지방의 비율이 어떻게 되느냐?
select
    job,
    count(*) as "총인원수",
    count(case
            when substr(address, 1, 2) = '서울' then 1
    end) as "서울 거주",
    count(case
            when substr(address, 1, 2) <> '서울' then 1
    end) as "서울 비거주",

    round(count(case
            when substr(address, 1, 2) = '서울' then 1
    end) / count(*) * 100, 2) as "서울 거주(%)",

    round(count(case
            when substr(address, 1, 2) <> '서울' then 1
    end) / count(*) * 100, 2) as "서울 비거주(%)"

from tblAddressBook
    group by job
        having job in ('건물주', '건물주자제분');

select * from tblAddressBook;


