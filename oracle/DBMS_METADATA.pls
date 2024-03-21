declare
    v_handle        number;
    v_t_handle      number;
    v_offset        number := 1;
    v_clob          clob;
    v_str           varchar2(255);
    v_multi_ddls    sys.ku$_multi_ddls;
    v_multi_ddl     sys.ku$_multi_ddl;
    v_ddls          sys.ku$_ddls;
    ddl             sys.ku$_ddl;
    i               PLS_INTEGER;
begin
    DBMS_OUTPUT.PUT_LINE('START');
    v_clob := SYS.DBMS_METADATA_DIFF.COMPARE_SXML(
        'TABLE',
        'TSDB_PERSON_CI_TEST',
        'TSDB_PERSON_CI_TEST',
        'ROBOT',
        'REPLICATOR'
    );

    loop exit when v_offset > SYS.dbms_lob.getlength(v_clob);
        v_str := SYS.dbms_lob.substr(v_clob, 255, v_offset);
        --DBMS_OUTPUT.PUT (v_str);
        v_offset := v_offset + 255;
    end loop;

    DBMS_OUTPUT.PUT_LINE('HERE');
    v_handle := SYS.DBMS_METADATA.OPENW('TABLE');
    DBMS_OUTPUT.PUT_LINE('HANDLE: ' || v_handle);
    v_t_handle := DBMS_METADATA.ADD_TRANSFORM(v_handle, 'ALTERXML');
    v_t_handle := DBMS_METADATA.ADD_TRANSFORM(v_handle, 'ALTERDDL');
    DBMS_OUTPUT.PUT_LINE ('T_HABDLE: ' || v_t_handle);
    v_multi_ddls := SYS.DBMS_METADATA.CONVERT(v_handle, v_clob);

    IF v_multi_ddls IS NULL THEN
        DBMS_OUTPUT.PUT_LINE ('v_multi_ddls IS NULL!');
        SYS.DBMS_METADATA.CLOSE(v_handle);
        RETURN;
    ELSIF v_multi_ddls.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE ('v_multi_ddls IS EMPTY!');
        SYS.DBMS_METADATA.CLOSE(v_handle);
        RETURN;
    END IF;

    FOR i IN v_multi_ddls.FIRST .. v_multi_ddls.LAST
    LOOP
        IF v_multi_ddls(i) IS NULL THEN
            DBMS_OUTPUT.PUT_LINE ('v_multi_ddls(' || i || ') IS NULL!');
        ELSE
            v_multi_ddl := v_multi_ddls(i);
            v_ddls := v_multi_ddl.ddls;

            IF v_ddls IS NULL THEN
                DBMS_OUTPUT.PUT_LINE ('v_ddls IS NULL!');
                SYS.DBMS_METADATA.CLOSE(v_handle);
                RETURN;
            ELSIF v_ddls.COUNT = 0 THEN
                DBMS_OUTPUT.PUT_LINE ('v_ddls IS EMPTY!');
                SYS.DBMS_METADATA.CLOSE(v_handle);
                RETURN;
            END IF;

            FOR j IN v_ddls.FIRST .. v_ddls.LAST
            LOOP
                IF v_ddls(j) IS NULL THEN
                    DBMS_OUTPUT.PUT_LINE ('v_ddls(' || j || ') IS NULL!');
                ELSE
                    v_clob := v_ddls(j).ddlText;
                    v_offset := 1;
                    loop exit when v_offset > SYS.dbms_lob.getlength(v_clob);
                        v_str := SYS.dbms_lob.substr(v_clob, 255, v_offset);
                        DBMS_OUTPUT.PUT_LINE (v_str);
                        v_offset := v_offset + 255;
                    end loop;
                END IF;
            END LOOP;
        END IF;
    END LOOP;

    SYS.DBMS_METADATA.CLOSE(v_handle);
    DBMS_OUTPUT.PUT_LINE('CLOSE');
end;