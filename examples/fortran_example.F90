program fortran_example

use fms_yaml_parser_mod,        only:fms_yaml_read, fms_yaml_key_value
use iso_c_binding

character (len=25) :: lineBuffer
character (len=:) , allocatable :: yamlString
character (len=1) :: newline
integer :: i
integer :: numlines
integer :: placeOld
integer :: placeNew
type (c_ptr) :: cptr
integer :: frequency

placeOld = 1
open (29, file="simple.yaml", status="old")

allocate(character (len=400):: yamlString)

numlines=19

do i = 1,numlines
 read(29,'(a)') lineBuffer
 placeNew = placeOld + len_trim(lineBuffer)
 yamlString(placeOld:placeNew+1) = trim(lineBuffer)//new_line(newline)
 placeOld = placeNew+2
 lineBuffer="                         "
enddo

cptr = fms_yaml_read (yamlString)

 call fms_yaml_key_value (yamlString, "diag_files/freq %d", frequency)
 write (6,*) "The frequency should be 24.  It is ", frequency
end program fortran_example
