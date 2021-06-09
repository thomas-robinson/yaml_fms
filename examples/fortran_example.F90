!***********************************************************************
!*                   GNU Lesser General Public License
!*
!* This file is part of the GFDL Flexible Modeling System (FMS).
!*
!* FMS is free software: you can redistribute it and/or modify it under
!* the terms of the GNU Lesser General Public License as published by
!* the Free Software Foundation, either version 3 of the License, or (at
!* your option) any later version.
!*
!* FMS is distributed in the hope that it will be useful, but WITHOUT
!* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
!* for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with FMS.  If not, see <http://www.gnu.org/licenses/>.
!***********************************************************************

!> @file
!! @brief Tests for YAML parsing 
!! @author Tom Robinson
!! @email gfdl.climate.model.info@noaa.gov
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
integer, parameter :: referenceFrequency = 24

!> Read in the YAML file.
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

!> Parse the YAML
cptr = fms_yaml_read (yamlString)
!> Read an integer value from the YAML
 call fms_yaml_key_value (yamlString, "diag_files/freq %d", frequency)
 !> Check the value
 if (frequency .ne. referenceFrequency) then
   write (6,550) "The frequency ",frequency," did not match the reference value ", referenceFrequency
 else
    write (6,550) "The frequency is ", frequency, " matching the reference value ",referenceFrequency
 endif

550 format (a,i2,a,i2)

end program fortran_example
