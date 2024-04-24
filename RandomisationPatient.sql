
CREATE OR REPLACE PROCEDURE Randomisation(NbPatient IN NUMBER) AS
DECLARE
    NbPGroupe number := NbPatient/4;
    nb_ligne number;
    age number;
    currentIDPatient number;
    randomGroupe number;
    randomSousGroupe number;
    typeOfGroupe varchar(2);
    TYPE IdArray IS TABLE OF VARCHAR2(2) INDEX BY NUMBER;
    patientIds IdArray := IdArray(1 => 'TV', 2 => 'TP', 3 => 'VP', 4 => 'PP');--tableau associatif
BEGIN
    
    for i in 1..NbPatient loop
   -- Boucle pour trouver un groupe au hasard et non complet
      
    select ID_PATIENT into currentIDPatient from PATIENT where ID_PATIENT = i AND TYPE_GROUPE = null;
    age := currentIDPatient.DDN_PATIENT - SYSDATE;--r�cup�ration de l'�ge du patient � ce jour
    
    loop
    
    randomGroupe := round(((DBMS_Random.value()*3)+1)); --Valeur au hasard entre 1 et 4
    typeOfGroupe := patientIds(randomGroupe); -- On recup�re la valeur associ�e dans notre tableau associatif
    randomSousGroupe := round(((DBMS_Random.value()*2)+1));
    
        SELECT COUNT(*) 
            INTO nb_ligne 
            FROM PATIENT 
            WHERE TYPE_GROUPE = typeOfGroupe AND TYPE_SOUS_GROUPE = randomSousGroupe;-- r�cup�ration du nombre de patient dans le groupe
            
        IF nb_ligne < NbPGroupe/3 then
            EXIT; -- Sortir de la boucle si le groupe est incomplet
        END IF;
    end loop;
    
        if age<50 then
        --le patient peut �tre dans les 3 sous groupes
        elsif age>=50 AND typeOfGroupe = PP
        --le patient peut �tre dans les 3 sous groupes
        else
        -- Le patient peut �tre que dans le 2eme et troisi�me sous groupe
    end loop;
        
    
END
/


