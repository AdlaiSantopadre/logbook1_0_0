**logbook filosofia della App**

*To make as easy as possible the start of the working day..*\
Prima di iniziare la specifica attività lavorativa (ad es. la
manutenzione programmata su un impianto *in itinere*), ogni giorno devo
ottemperare a tutta una serie di piccole attività iniziali ( compiti per
lo più di verifica e controllo degli equipaggiamenti e dell\'autoveicolo
che andrò ad utilizzare).\
Sono per lo più moduli e liste di controllo da compilare in forma
cartacea, riconducibili a Ordini di servizio e Norme più in generale.\
Il mio inquadramento aziendale come operaio addetto agli impianti non
presuppone necessariamante che ci sia da un lato un compendio
organizzato delle attività da svolgere, e dall\'altro un unico strumento
che raccolga e tracci quanto fatto.\
Pertanto in partenza sarebbe ideale raggruppare le attività in un elenco
gestibile *a colpo d\'occhio*, specialmente per avere sotto mano
scadenze da non dimenticare, attività prioritarie e/o indifferibili.

Successivamente, dal bisogno di rendicontare o consultare, anche la
reportistica potrebbe essere resa omogenea e tradotta in forma digitale,
non impedendo all\'occorrenza una consultazione pronta e efficace

**Progetto della App**

La UI della App si compone di 13 screen(routes) su tre livelli (di
navigazione):

Al livello 0 si trova la HomePage di tipo material che comprende un
Navigation Drawer e permette di accedere ad una maschera Popup di
navigazione

Dal Drawer si accede al liv.1 ad una serie di pagine, una per ogni
componente tematico della App le quali a loro volta permettono di
navigare al livello 2 ed accedere al liv.2 Quindi la navigazione è
orizzontale solo tre HomePage, Drawer e HomePage e Popup

![Struttura Navigazione](lib/assets/StrutturaNavigazione.png)

Pagina iniziale della App. Contiene l\`accesso al drawer per la
navigazione

Permette di scegliere (e memorizzare la data della attività), lanciare
la autenticazione tramite popup, consultare la lista delle scadenze,
avere un colpo d\`occhio tramite indicatore di progresso per l\`avvio
delle attività, e se il livello di progresso abilita il pulsante
flottante chiudere la app salvando i dati aggiornati

Ho implementato l\`autenticazione con una richiesta (si preme , si apre
una popup, e username e password validati secondo regole vengono
aggiornati come testo visualizzato nella Homepage

Ho implementato un datario per scegliere la data di inizio attività
(dovrò scegliere anche la data (orario di fine attività).
