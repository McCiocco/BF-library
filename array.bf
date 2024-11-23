In questo documento propongo una implementazione degli array in brainfuck che permette di:
    raggiungere rapidamente l'array da qualsiasi punto della memoria si trovi
    scrivere algoritmi che funzionano su qualsiasi array (indipendentemente da suo identificatore)
    Scrivere algoritmi piu semplici grazie a celle di scarto incluse
    leggere in tempo costante la grandezza dell'array

NOTAZIONE: nx vuol dire n piu x
           cx* vuol dire che la cella cx e' attualmente puntata

Per creare un array di lunghezza n sono necessarie n9 celle riservate e sequenziali definite
ed ordinate nel seguente modo

c0      c1       da c2 a c6    c7        da c8 a n8
id    tempid       scarto       n     memoria effettiva

Stato iniziale: (mentre non si sta lavorando sull'array)
id      0            0          n         qualsiasi

id e' un identificatore (vedi il file identificatori per maggiori dettagli) che rimane associato
unicamente per questo array

tempid e' un secondo identificatore che normalmente e' settato a 0 ma quando si lavora sull'array
viene temporaneamente settato a neg1; questo ha dei grandi vantaggi; per esempio (come vedremo
nell'esempio sull'indicizzazione) permette di scrivere algoritmi che sanno tornare all'inizio
dell'array senza conoscere il valore di id

le celle di scarto (c2 a c6) vengono tenute per ogni array cosi da poter essere utilizzate in 
qualunque algoritmo ; a prescindere da dove sono tenute le celle di scarto globali;  e ridurre il
numero di loop computazionalmente pesanti in cui ci si muove su lunghe distanze per cercarle

Ora inserisco; opportunamente commentato; un algoritmo che individua l'iesimo elemento dell'array
(con uno indexing)

Ipotesi: i si trova nella cella di scarto c6; c6*

<<<<<                                     Inizializzazione dell'identificatore temporaneo
-
>>>>>

[-<+<+>>]<[->+<]>                         Copia i in c4 ; c4*

[                                         Mentre i != 0 (in ci)
    >[-<<+>>]<                            Sposta la cella successiva a quella di i due indietro; ci*
    [->+<]                                Sposta i in ci1 ; ci*
    >-                                    Diminuisce i di 1 ; ci1*

]
-->                                       Setta la cella prima della iesima a neg2 ; ci*
[                                         Inizia una copia di ci in c2
    -                                     Decrementa ci ;
    +[-<+]-                               glider a c1
    >+>+                                  Incrementa c2 e c3
    ++[-->++]--                           glider a cimeno1
    >                                     torna a ci

]
+[-<+]->>                                 Vai a c3
[                                         Sposta c3 in ci
    -                                     Decrementa c3
    ++[-->++]-- >                         ci*
    +                                     Incrementa ci
    +[-<+]->>                             Torna a c3

]
>                                         c4*
[                                         Sposta i (c4) in cimeno2
    -
    ++[-->++]-- <
    +
    +[-<+]- >>>

]
++[-->++]--                               cimeno1*
++
<                                         ci*
[                                         Mentre i != 0
    < [->>+<<]                            Sposta la cella prima di i dopo i ; cimeno1*
    > [-<+>] < -                          Sposto i indietro e lo decremento

]                                         c5*

<<<<
+
>                                         Riporta tempid a 0 e c2*


Sintetico:

<<<<<->>>>>[-<+<+>
>]<[->+<]>[>[-<<+>
>]<[->+<]>-]-->[-+
[-<+]->+>+++[-->++
]-->]+[-<+]->>[-++
[-->++]-->++[-<+]-
>>]>[-++[-->++]--<
++[-<+]->>>]++[-->
++]--++<[<[->>+<<]
>[-<+>]<-]<<<<+>
