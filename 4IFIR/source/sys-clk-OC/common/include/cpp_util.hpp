#pragma once

#include <utility>

template<typename F>
class ScopeGuard {
public:
    ScopeGuard(F&& f)
     : f(f), engaged(true) {};

    ~ScopeGuard() {
        if (engaged)
            f();
    };

    ScopeGuard(ScopeGuard&& rhs)
     : f(std::move(rhs.f)) {};

    void dismiss() { engaged = false; }

private:
    F f;
    bool engaged;
};

struct MakeScopeExit {
    template<typename F>
    ScopeGuard<F> operator+=(F&& f) {
        return ScopeGuard<F>(std::move(f));
    };
};

#define STRING_CAT2(x, y) x##y
#define STRING_CAT(x, y) STRING_CAT2(x, y)
#define SCOPE_GUARD MakeScopeExit() += [&]() __attribute__((always_inline))
#define SCOPE_EXIT auto STRING_CAT(scope_exit_, __LINE__) = SCOPE_GUARD