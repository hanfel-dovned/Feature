/-  feature
/+  dbug, default-agent, server, schooner
/*  feature-ui  %html  /app/feature-ui/html
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 page=@t]
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
=|  state-0
=*  state  -
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this(page 'Hello World')
  :~
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/feature  %feature
    ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  (on-poke:def mark vase)
      %handle-http-request
    ?>  =(src.bowl our.bowl)
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  (quip card _state)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    =+  send=(cury response:schooner eyre-id)
    ::
    ?+    method.request.inbound-request  
      [(send [405 ~ [%stock ~]]) state]
      ::
        %'POST'
      ?.  authenticated.inbound-request
        :_  state
        %-  send
        [302 ~ [%login-redirect './apps/feature']]
      ?~  body.request.inbound-request
        [(send [405 ~ [%stock ~]]) state]
      =/  json  (de-json:html q.u.body.request.inbound-request)
      =/  action  (dejs-action +.json)
      (handle-action action) 
      :: 
        %'GET'
      ?+    site  
          :_  state 
          (send [404 ~ [%plain "404 - Not Found"]])
        ::
          [%apps %feature %public ~]
        :_  state
        %-  send
        :+  200  ~  
        :-  %html  page
        ::
          [%apps %feature ~]
        ?.  authenticated.inbound-request
          :_  state
          %-  send
          [302 ~ [%login-redirect './apps/feature']]
        :_  state
        %-  send
        :+  200  ~  
        :-  %html  feature-ui
        ::
        ::    [%apps %feature %state ~]
        ::  :_  state
        ::  %-  send
        ::  :+  200  ~ 
        ::  [%json (enjs-state +.state)]
      == 
    ==
  ::
  ::  ++  enjs-state
  ::    =,  enjs:format
  ::    |=  state=(unit @p)
  ::    ^-  json
  ::    ?^  state
  ::      (ship +:state)
  ::    (numb 0)
  ::
  ++  dejs-action
    =,  dejs:format
    |=  jon=json
    ^-  action:feature
    %.  jon
    %-  of
    :~  new-page+so
    ==
  ::
  ++  handle-action
    |=  =action:feature
    ^-  (quip card _state)
    ?-    -.action
        %new-page
      ?>  =(src.bowl our.bowl)
      `state(page html:action)
    ==
  --
++  on-peek  on-peek:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--