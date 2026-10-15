---
name: power-map
description: Maps the power structure behind any outcome the user wants from other people (a sale, a fundraise, a hire, a partnership, an approval, a regulator, an internal decision, a negotiation, product adoption) as a graph of actors, the exact decision and money flow, each actor's incentives and Jobs-To-Be-Done profile, their STATE on a commitment ladder, and the moves that shift each state, then finds the leverage point where one change cascades. Deep-researches the actors that matter. Use when the user says power map, power structure, who decides, who is involved, map the stakeholders, how do I get X to say yes, influence map, leverage, who holds the power, decision makers, org map, follow the money, incentive map, or asks how to move a person or a system toward a decision.
argument-hint: <outcome you want> [actors / context you already know]
---

# power-map

One outcome, one graph, one move list. Every actor on the graph has a role, an incentive card, a STATE with evidence, and a next move. Generic "stakeholder analysis" prose is banned; the output is the map and the moves.

## Output shape (always these five blocks, in this order)

1. **Outcome line.** One sentence, measurable, dated: "X signs Y by <date>", "committee approves Z at the <date> meeting".
2. **Flow diagram (ASCII).** The exact path from trigger to done: steps, gates, who signs, what moves on each edge (money, data, approval, a recommendation). Every gate names its owner.
3. **Actor cards.** One per actor, fixed fields (below).
4. **Leverage.** The one node whose state change cascades, the coalition order, the lever per key actor.
5. **Move list.** Ordered: actor, state now -> target state, lever, the ask (message-level), the proof you bring, the risk, the check that it worked.

## Actor card (fixed fields, all present or marked `unknown`)

```
ACTOR: <name / role>            power: decide | veto | delay | recommend | execute | inform | pay | affected
formal:   <what they can sign, block, fund>
informal: <trust, information, relationships, who listens to them, who they listen to>
measured on: <the number their boss looks at>     fears: <what a wrong yes costs them>     gains: <what a right yes gives them>
JTBD: functional <the job they hire this decision for> | emotional <how they want to feel> | social <how they want to look>
constraints: <budget, calendar, policy, precedent>
STATE: opposed | unaware | aware | interested | evaluating | convinced | committed | acting | done   [SEEN|TESTED|READ|GUESS] <evidence>
next move: <one rung up, the lever, the ask>
```

`power:` lists every role that applies, primary first (`recommend | delay`). Non-person actors (a policy, a lint bot, an algorithm, a deadline, a budget rule) get the short CONSTRAINT card instead, never n/a fields:

```
CONSTRAINT: <name>               power: veto | delay | execute
rule: <what it checks or enforces, quoted or cited>     trigger: <what makes it fire>
satisfied by: <the exact input that passes it>
STATE: fires | does not fire | unknown   [SEEN|TESTED|READ|GUESS] <evidence>
next move: <what to change so it does not fire, or who owns an exception>
```

Evidence tags: SEEN (you observed it: an email, a call, a document), TESTED (you probed and got a reaction), READ (public source, cite it), GUESS (inference, say from what). A STATE with no tag is a finding against the map. A public policy doc earns READ on the CONSTRAINT card only; a person's STATE stays GUESS until you observed or probed that person.

## Procedure

1. **Outcome first.** Get the one outcome and the date. No outcome, no map; ask. The outcome line is the user's literal ask (a sub-step stays a sub-step); the flow may show the surrounding process.
2. **Reality dump.** Collect what the user already holds: threads, org charts, contracts, past decisions, LinkedIn, the last meeting's notes. Read them before drawing anything. Then check the user's facts against each other and against how each actor defines terms: a contradiction is the first finding and goes above the map (example: "no data at rest" next to "tokens stored in KV", which most security reviewers call data at rest). A map drawn on a premise the actor rejects produces confident, wrong moves.
3. **Actor census.** Everyone who touches the outcome: decides, vetoes, delays, recommends, executes, pays, informs, is affected. Include the invisible ones: legal, finance, procurement, the assistant who owns the calendar, the incumbent vendor, the champion's boss, the policy, the algorithm, the deadline. Gate: any actor holding a veto who is missing = the map is incomplete; hunt until the census closes.
4. **Flow.** Draw the decision path as it really runs, not the org chart: trigger -> steps -> gates -> signature -> what moves. Mark each edge with what passes and what the receiver needs before saying yes.
5. **Cards.** Fill every card. Incentives come from what the actor is measured on and what they fear, not from what they say. STATE gets a tag and an evidence line.
6. **Deep research the actors that matter.** Priority = power x distance from the target state. Top actors: `/deep-research` (public statements, past decisions of the same kind, career pattern, what they reward versus what they claim to value, their boss's incentives). The rest: cheap subagents (Sonnet or Haiku) with a fixed card to fill. Every claim cited or tagged GUESS. For any actor who posts in public, read them in their own words first: `bash chrome/bin/x_search.sh "from:<handle> <topic> since:<date>"` (free, logged-in Chrome; paid fallback `bash openrouter-bridge/xsearch.sh --handles <handle> --from <date> "..."`) (X is unreadable to ordinary web search, and an actor's own posts are the cheapest honest read on what they are measured on, who they credit, and what they fear). Their replies and quote-tweets name allies and rivals the org chart hides; a handle that posts nothing is itself a card field.
7. **Leverage.** (a) System: the one node whose state change cascades (the constraint; `/godview` lens when unclear; ask the ecology question too: what does the decider depend on, and what shares their scarce resource such as budget, calendar or political capital; the cascade node is often the dependency, not the decider, see godview `reference/structure-transfer.md` F4 and F5), the coalition order (whom to convince first so the next yes gets cheaper), each side's BATNA. (b) Per actor: the path through the graph to the person they listen to, the proof they need, what removes their fear, the timing window, and the Cialdini lever that fits their JTBD (reciprocity, commitment, social proof, authority, liking, scarcity). One lever per move, named.
8. **Move list.** Ordered, each with the check that proves the state moved. Update the map as reality answers; a state that did not move after a move is a wrong card, fix the card before the next move.

## Rules that bind

- Ban: prose summaries in place of the five blocks. Test: a stranger can answer "what does this actor get, what do they fear, where are they now" for every actor from the cards alone.
- Ban: a move without a named state transition and a named lever.
- Ban: an incentive or state claim with no evidence tag. GUESS is allowed; untagged is not.
- Ban: `n/a` in a card field. A field that does not apply means the actor needs the CONSTRAINT card.
- Ban: an org chart pasted as the flow. The flow is the path the decision actually travels, which usually skips boxes and adds invisible ones.
- No em dashes.

## Examples

Input: `/power-map get our Slack app listed in the Slack Marketplace by Oct 15; I know: my test workspace Company.ai, the app A0BJSMDMG4Q, the review form, one prior rejection email citing scopes`
Output:
- Outcome line: "App A0BJSMDMG4Q approved and listed in the Slack Marketplace by 2026-10-15."
- Flow: `submit form -> automated scope/security lint (bot) -> App Review queue -> reviewer (human, checks scopes vs stated use, privacy policy URL, support contact, test creds) -> [gate: security questionnaire if data-at-rest] -> approve / reject with template email -> listing live`. Edge labels: what the reviewer needs = a test workspace login that reproduces every scope's use in under 10 minutes.
- Cards: Reviewer (power: decide; measured on queue throughput and zero post-approval incidents; fears an app that leaks workspace data on their approval; JTBD functional = clear the ticket with no follow-up, emotional = not be the one who approved a bad app; STATE: aware, READ: the rejection email cites `channels:history` without a demonstrated need). Security questionnaire owner (power: veto; unknown person, GUESS from the form's data-at-rest branch). The user (power: execute). The prior rejection template as a CONSTRAINT card (rule: scopes must match a demonstrated use; trigger: any scope with no shown use; satisfied by: a screencast per scope; STATE fires, SEEN in the rejection email).
- Leverage: the reviewer's fear is the constraint; the cheapest cascade is a 2-minute screencast that shows every scope in use plus dropping `channels:history`. Coalition order: fix scopes first (removes the veto trigger), then resubmit with the screencast and test creds in the form's notes field.
- Move list: (1) scope diff, remove 2 scopes, STATE reviewer aware -> evaluating, lever = removing the stated objection, check = no scope line in the next reply; (2) resubmit with screencast + creds, lever = reciprocity (do the reviewer's verification work for them), check = ticket moves to review within 5 business days; (3) if the security questionnaire branch fires, answer within 24 h citing the Worker-only architecture, GUESS on owner, check = no second-round questions.

Input: `/power-map raise a $1.5M pre-seed from fund F by end of Q4; I have the partner's intro email and one prior call with an associate`
Output: outcome line with the date; a flow that runs associate screen -> partner call -> partner Monday meeting (gate: another partner's non-objection) -> term sheet -> legal; cards for the associate (power: recommend; measured on deals that get to partner and are not embarrassing; STATE evaluating, SEEN: asked for cohort data on the call), the sponsoring partner (power: decide; JTBD social = bring a deal the others admire; STATE interested, GUESS from the intro's wording), the skeptical partner (power: veto; unknown, research task), legal (delay); leverage = the sponsoring partner's Monday pitch, so the move list arms the partner with the one-slide memo they can read aloud, sequences a customer reference call before Monday, and names the check for each step (calendar invite for partner call, associate forwards the memo, term sheet draft).
