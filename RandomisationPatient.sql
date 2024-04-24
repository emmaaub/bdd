CREATE OR REPLACE TRIGGER RandomizeGroupAndSubgroupVersionHaute
BEFORE INSERT ON PATIENT
FOR EACH ROW
DECLARE
    total_tv NUMBER := 0;
    total_tp NUMBER := 0;
    total_vp NUMBER := 0;
    total_pp NUMBER := 0;
    chosen_group VARCHAR2(10);
    chosen_subgroup NUMBER := 0;
    age_patient NUMBER := 0;
    min_group_size NUMBER := 0;
    chosen_subgroup_random NUMBER := 0;
    chosen_group_random VARCHAR2(10);
BEGIN
    -- Calculer le nombre de patients actuels dans chaque groupe
    SELECT COUNT(*) INTO total_tv FROM PATIENT WHERE Type_Groupe = 'TV';
    SELECT COUNT(*) INTO total_tp FROM PATIENT WHERE Type_Groupe = 'TP';
    SELECT COUNT(*) INTO total_vp FROM PATIENT WHERE Type_Groupe = 'VP';
    SELECT COUNT(*) INTO total_pp FROM PATIENT WHERE Type_Groupe = 'PP';

    -- Déterminer le minimum de patients parmi les groupes TV, TP, VP
    min_group_size := LEAST(total_tv, total_tp, total_vp, total_pp);

    -- Déterminer le nombre de patients par sous-groupe dans chaque groupe
    DECLARE
        num_tv_subgroup1 NUMBER := 0;
        num_tv_subgroup2 NUMBER := 0;
        num_tv_subgroup3 NUMBER := 0;
        num_tp_subgroup1 NUMBER := 0;
        num_tp_subgroup2 NUMBER := 0;
        num_tp_subgroup3 NUMBER := 0;
        num_vp_subgroup1 NUMBER := 0;
        num_vp_subgroup2 NUMBER := 0;
        num_vp_subgroup3 NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO num_tv_subgroup1 FROM PATIENT WHERE Type_Groupe = 'TV' AND Type_Sous_Groupe = 1;
        SELECT COUNT(*) INTO num_tv_subgroup2 FROM PATIENT WHERE Type_Groupe = 'TV' AND Type_Sous_Groupe = 2;
        SELECT COUNT(*) INTO num_tv_subgroup3 FROM PATIENT WHERE Type_Groupe = 'TV' AND Type_Sous_Groupe = 3;
        SELECT COUNT(*) INTO num_tp_subgroup1 FROM PATIENT WHERE Type_Groupe = 'TP' AND Type_Sous_Groupe = 1;
        SELECT COUNT(*) INTO num_tp_subgroup2 FROM PATIENT WHERE Type_Groupe = 'TP' AND Type_Sous_Groupe = 2;
        SELECT COUNT(*) INTO num_tp_subgroup3 FROM PATIENT WHERE Type_Groupe = 'TP' AND Type_Sous_Groupe = 3;
        SELECT COUNT(*) INTO num_vp_subgroup1 FROM PATIENT WHERE Type_Groupe = 'VP' AND Type_Sous_Groupe = 1;
        SELECT COUNT(*) INTO num_vp_subgroup2 FROM PATIENT WHERE Type_Groupe = 'VP' AND Type_Sous_Groupe = 2;
        SELECT COUNT(*) INTO num_vp_subgroup3 FROM PATIENT WHERE Type_Groupe = 'VP' AND Type_Sous_Groupe = 3;

        -- Déterminer le sous-groupe avec le nombre minimum de patients dans chaque groupe
        CASE chosen_group
            WHEN 'TV' THEN
                IF num_tv_subgroup1 = 0 THEN
                    chosen_subgroup := 1;
                ELSIF num_tv_subgroup2 = 0 THEN
                    chosen_subgroup := 2;
                ELSIF num_tv_subgroup3 = 0 THEN
                    chosen_subgroup := 3;
                END IF;
            WHEN 'TP' THEN
                IF num_tp_subgroup1 = 0 THEN
                    chosen_subgroup := 1;
                ELSIF num_tp_subgroup2 = 0 THEN
                    chosen_subgroup := 2;
                ELSIF num_tp_subgroup3 = 0 THEN
                    chosen_subgroup := 3;
                END IF;
            WHEN 'VP' THEN
                IF num_vp_subgroup1 = 0 THEN
                    chosen_subgroup := 1;
                ELSIF num_vp_subgroup2 = 0 THEN
                    chosen_subgroup := 2;
                ELSIF num_vp_subgroup3 = 0 THEN
                    chosen_subgroup := 3;
                END IF;
            ELSE
                chosen_subgroup := 0;
        END CASE;
    END;

    -- Déterminer le groupe en fonction de la disponibilité de patients
    IF total_tv = 0 AND total_tp = 0 AND total_vp = 0 AND total_pp = 0 THEN
        -- Aucun patient dans TV, TP, VP et PP -> choisir aléatoirement parmi TV, TP, VP
        chosen_group_random := TRUNC(DBMS_RANDOM.VALUE(1, 5));
        if chosen_group_random = 1 then
            chosen_group := 'TV';
        elsif chosen_group_random = 2 then
            chosen_group := 'TP';
        elsif chosen_group_random = 3 then
            chosen_group := 'VP';
        elsif chosen_group_random = 4 then
            chosen_group := 'PP';
        end if;
    ELSIF total_tv > 0 AND total_tp > 0 AND total_vp > 0 AND total_pp > 0 THEN
        -- Tous les groupes sont non vides -> vérifier la taille de chaque groupe
        IF min_group_size = total_tv THEN
            chosen_group := 'TV';
        ELSIF min_group_size = total_tp THEN
            chosen_group := 'TP';
        ELSIF min_group_size = total_vp THEN
            chosen_group := 'VP';
        else
            chosen_group := 'PP';
        END IF;
    ELSE
        -- Un des groupes n'est pas vide -> choisir aléatoirement entre TV, TP, VP
        chosen_group_random := TRUNC(DBMS_RANDOM.VALUE(1, 5));
        if chosen_group_random = 1 then
            chosen_group := 'TV';
        elsif chosen_group_random = 2 then
            chosen_group := 'TP';
        elsif chosen_group_random = 3 then
            chosen_group := 'VP';
        elsif chosen_group_random = 4 then
            chosen_group := 'PP';
        end if;
    END IF;

    -- Déterminer le sous-groupe en fonction de l'âge du patient
    age_patient := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.DDN_Patient) / 12);

    IF age_patient > 50 THEN
        IF chosen_group IN ('TV', 'TP', 'VP') THEN
            -- Si le patient a plus de 50 ans, assigner au sous-groupe 2 ou 3
            chosen_subgroup_random := TRUNC(DBMS_RANDOM.VALUE(1, 3));
                if chosen_subgroup_random = 1 then
                    chosen_subgroup := 2;
                else
                    chosen_subgroup := 3;
                end if;
        END IF;
    ELSE
        if chosen_group IN ('TV', 'TP', 'VP') THEN
            -- Sinon, choisir aléatoirement parmi les sous-groupes 1, 2, 3
            chosen_subgroup_random := TRUNC(DBMS_RANDOM.VALUE(1, 4));
                if chosen_subgroup_random = 1 then
                    chosen_subgroup := 1;
                elsif chosen_group_random = 2 then
                    chosen_subgroup := 2;
                else 
                    chosen_subgroup := 3;
                end if;
        else
            chosen_subgroup := 0;
        end if;
    END IF;

    -- Affecter le groupe et le sous-groupe choisis au nouveau patient
    :NEW.Type_Groupe := chosen_group;
    :NEW.Type_Sous_Groupe := chosen_subgroup;
END;
/