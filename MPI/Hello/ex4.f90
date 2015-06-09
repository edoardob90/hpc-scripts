PROGRAM main

! A minimal MPI program
! ---------------------

IMPLICIT NONE
INCLUDE 'mpif.h'


! Each task owns its private set of the following variables
! ---------------------------------------------------------

INTEGER       :: my_rank, tasks_number
CHARACTER*32  :: machine_name
INTEGER       :: ierr, name_length


! We should start with...
! -----------------------

CALL MPI_INIT (ierr)


! Getting information about the MPI environnement
! -----------------------------------------------

CALL MPI_COMM_RANK (MPI_COMM_WORLD, my_rank, ierr)
CALL MPI_COMM_SIZE (MPI_COMM_WORLD, tasks_number, ierr)
CALL MPI_GET_PROCESSOR_NAME (machine_name, name_length, ierr)

write ( *, '(a,i5,a,i5,a,a)' ) &
  & 'Hello, my rank is ', &
  & my_rank, ' among ', tasks_number, &
  & ' tasks on machine ', machine_name (1:name_length)


! ...and we should terminate by...
! --------------------------------

CALL MPI_FINALIZE (ierr)
  
END PROGRAM main
