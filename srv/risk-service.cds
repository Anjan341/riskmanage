using { riskmanagement as rm } from '../db/schema';
@path: 'service/risk'
service RiskService {
entity Risks as projection on rm.Risks {
    *, // All existing fields
        case
            when prio_code = 'H' then 3
            when prio_code = 'M' then 2
            when prio_code = 'L' then 1
            else 0
        end as criticality: Integer
};   

annotate Risks with @odata.draft.enabled ;
 
 
entity Mitigations as projection on rm.Mitigations;
annotate Mitigations with @odata.draft.enabled;

}
// UI annotations to enable color--

annotate riskmanagement.Risks with @(
    UI.LineItem    : [
        { Value : ID }  ,   
        {Value : title }   ,
        { Value : owner },
    {
            Value : prio_code,
            /** * This line is the "magic." It tells the UI to look at the
             * 'criticality' field to decide the color for 'prio_code'.
             */
            Criticality : criticality,
            CriticalityRepresentation : #WithIcon
        },
        {
            Value : descr,
            Criticality : criticality
        },
        { Value : impact }
    ],
   
    UI.HeaderInfo : {
        TypeName : 'Risk',
        TypeNamePlural : 'Risks',
        Title : { Value : title },
        Description : { Value : descr }
    },
 
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Main Information',
            Target : '@UI.FieldGroup#Main',
        }
    ],
   
    UI.FieldGroup #Main : {
        Data : [
            { Value : title },
            { Value : owner },
            {
                Value : prio_code,
                Criticality : criticality
            },
            { Value : impact }
        ]
    }
);