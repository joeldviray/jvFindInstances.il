procedure(jvFindInstances()
        enterPoints(?addPointProc "inst_Add" ?cmdName "FindInstance")
)

procedure(inst_Add(win points)
        let((point obj instList n listLegth )
                cv = win->cellView
                instancesList=()
                when(and(windowp(win) dbobjectp(cv))
                        if(or(cv->cellViewType == "maskLayout" cv->cellViewType == "maskLayoutXL")
                        then
                                when(point = car(last(points))
                                        when(deGetEIP(win)
                                                point = geWindowToEditPoint(win point)
                                        )
                                        if(point=hiGetPoint(hiGetCurrentWindow())
                                        then
                                                let((wbox sz loc inStr div)

                                                     instList=leSearchHierarchy(cv list(point point) 32 "inst" nil)

                                                     ; Remove Duplication  
                                                     instList=myUniqueList(instList)

                                                     if(instList
                                                         then
                                                     listLegth = length( instList )

                                                      for( n 1 listLegth
                                                        instancesList=append1(instancesList nthelem( n instList~>cellName ))
                                                         )
                                                         else printf("Nothing found under the cursor/at given point!\n")
                                                         )
                                                         ; Remove Duplications
                                                         instancesList=myUniqueList(instancesList)
                                                         printf("Detected Instances: %N\n" instancesList)

                                                         ; For first time window opening
                                                         unless(boundp('selectiveEIPForm)
                                                           createSelectiveEIPForm()
                                                          selectiveEIPForm~>viewInsts~>choices=instancesList
                                                          )
                                                          selectiveEIPForm~>viewInsts~>choices=instancesList

                                                         ; Show the Form
                                                         selectiveEIPApp()

                                                       ) ; let 
                                        else
                                                printf("*INFO* No valid instance at point.")
                                        )
                                )
                        else
                                printf("*INFO* CellView is not a layout - %s : %s" cv->cellName cv->cellViewType)
                        )
                )
        )
)

;---------------------------
; Remove List's Duplications
;---------------------------
procedure(myUniqueList(aList)
    let((uTable newList)
        uTable = makeTable("uTable" nil)
        foreach(element aList
            unless(uTable[element]
                newList = cons(element newList)
                uTable[element] = t
            )
        )
        reverse(newList)
    )
)



;--------------------
; Creating the form
;--------------------
procedure( createSelectiveEIPForm()
   let( (viewInsts viewNameR selectEIP)

     viewNameR=hiCreateStringField(
                ?name 'viewNameR
                ?prompt "CellView Name"
                ?value ""
                ?callback ""
                )

     selectEIP = hiCreateButton(
        ?name           'selectEIP
        ?buttonText     "EIP"
        ?callback       "leEditInPlace(hiGetCurrentWindow() list(list(dbFindAnyInstByName(geGetEditCellView() car(selectiveEIPForm->viewInsts->value)) 0 0 0)))"
                )


     viewInsts = hiCreateListBoxField(
          ?name    'viewInsts
          ?choices instancesList
          ?multipleSelect nil
                        )

      hiCreateAppForm(
         ?name 'selectiveEIPForm
         ?formTitle "Selective EIP"
         ?fields list(
                    list(viewNameR 0:5 400:30 200)
                    list(viewInsts 0:35 400:120 200)
                    list(selectEIP 20:120 100:30 200)
                     )
         ?callback ""
         ?initialSize list(450 450)
      ) ;hiCreateAppForm

      hiDisplayForm('selectiveEIPForm)

   ) ;let
) ;procedure


;-------------
; Entry point
;-------------
procedure(selectiveEIPApp()
    unless(boundp('selectiveEIPForm)
        createSelectiveEIPForm()
        )
    hiDisplayForm(selectiveEIPForm)
    )

