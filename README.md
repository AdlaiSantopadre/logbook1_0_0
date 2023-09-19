**Logbook. Filosofia della App**

*To make as easy as possible the start of the working day.*

Prima di iniziare la specifica attività lavorativa (ad es. la
manutenzione programmata su un impianto *in itinere*), ogni giorno devo
ottemperare a tutta una serie di piccole attività iniziali (compiti, in
sintesi, di verifica e controllo degli equipaggiamenti e
dell\'autoveicolo che andrò ad utilizzare).

Sono per atteso da moduli e liste di controllo da compilare in forma
cartacea, riconducibili a Ordini di servizio e Norme più in generale. Il
mio inquadramento aziendale come operaio addetto agli impianti non
presuppone necessariamente che ci sia da un lato un compendio
organizzato delle attività da svolgere, e dall\'altro un unico strumento
che raccolga e tracci quanto fatto. Pertanto in partenza sarebbe ideale
raggruppare le attività di inizio giornata in un elenco gestibile *a
colpo d\'occhio*, specialmente per avere sotto mano scadenze, da non
dimenticare, di attività prioritarie e/o indifferibili.

Successivamente dal bisogno di rendicontare o consultare, potrebbe
essere resa omogenea e tradotta in forma digitale, anche la
reportistica, non impedendo all\'occorrenza una consultazione pronta ed
efficace.

**Progetto della App.Navigazione**

La UI della App si compone di 13 screen(routes) su tre livelli (di
navigazione).

Al livello 0 si trova la HomePage di tipo material che comprende un
Navigation Drawer e permette di accedere ad una maschera Popup di
autenticazione.

Dal Drawer si accede ad una serie di pagine al liv.1, una per ogni
attività della App. Queste pagine a loro volta permettono di navigare al
livello 2.

Quindi la navigazione è orizzontale solo tra HomePage \<-\> Drawer e
HomePage \<-\> Popup

![Struttura Navigazione](lib/assets/StrutturaNavigazione.png)

**HomePage**

Come pagina iniziale della App contiene i punti di accesso.

Contiene l'accesso al *Drawer* per la navigazione secondo il design di
una *Material App;*

permette di scegliere e memorizzare la data della attività;

avviare la autenticazione tramite Popup;

\[consultare la lista delle scadenze\];

avere un colpo d'occhio tramite un indicatore di progresso dei compiti
svolti;

se il livello di progresso raggiunto è sufficiente chiudere la app
\[salvando i dati aggiornati\]

Ho implementato l\`autenticazione con una richiesta (si preme , si apre
una popup, e username e password validati secondo regole vengono
aggiornati come testo visualizzato nella Homepage

Ho implementato un datario per scegliere la data di inizio attività
(dovrò scegliere anche la data (orario di fine attività).
